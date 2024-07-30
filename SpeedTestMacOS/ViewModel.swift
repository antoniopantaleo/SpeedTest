//
//  ViewModel.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 30/07/24.
//

import Foundation
import SpeedTestCore

protocol BitrateFormatter {
    var locale: Locale { get }
    func format(_ bits: Int) -> String
}

struct ByteCountBitrateFormatter: BitrateFormatter {
    
    let locale: Locale
    
    init(locale: Locale = .current) {
        self.locale = locale
    }
    
    private var formatter: ByteCountFormatStyle {
        ByteCountFormatStyle(
            style: .decimal,
            allowedUnits: [.bytes, .kb, .mb, .gb, .tb],
            locale: locale
        )
    }
    
    func format(_ bits: Int) -> String {
        let formattedSize = formatter.format(Int64(bits))
        let bytesRegex = /byte(?:s)?$/
        let otherUnitsRegex = /B$/
        var transformedSize = formattedSize
        if let match = try? bytesRegex.firstMatch(in: formattedSize) {
            transformedSize =  formattedSize.replacingCharacters(in: match.range, with: "b")
        } else if let match = try? otherUnitsRegex.firstMatch(in: formattedSize) {
            let lowercasedLetter = formattedSize[match.range].lowercased()
            transformedSize =  formattedSize.replacingCharacters(in: match.range, with: lowercasedLetter)
        }
        return transformedSize + "/s"
    }
}

@Observable
final class ViewModel {
    
    private let speedTester: SpeedTester
    private let bitrateFormatter: BitrateFormatter
    
    init(
        speedTester: SpeedTester,
        bitrateFormatter: BitrateFormatter
    ) {
        self.speedTester = speedTester
        self.bitrateFormatter = bitrateFormatter
    }
    
    enum State {
        case idle
        case loading
        case failure
    }
    
    private(set) var state: State = .idle
    private(set) var measurement: SpeedTestCore.Measurement?
    
    var downloadBitrate: String {
        guard let measurement else { return "-" }
        return bitrateFormatter.format(measurement.downlinkThroughput)
    }
    
    var uploadBitrate: String {
        guard let measurement else { return "-" }
        return bitrateFormatter.format(measurement.uplinkThroughput)
    }
    
    private var task: Task<Void, Never>?
    
    func performSpeedTest() {
        state = .loading
        task = Task {
            defer { task = nil }
            do {
                let measurement = try await speedTester.performSpeedTest()
                state = .idle
                if task?.isCancelled == true { return }
                self.measurement = measurement
            } catch {
                state = .failure
            }
        }
    }
    
    func cancelRunningSpeedTest() {
        task?.cancel()
    }
    
    func speedTestTime(
        calendar: Calendar = Calendar(identifier: .gregorian),
        locale: Locale = .current
    ) -> String {
        let fallback = "-"
        guard let measurement else { return fallback }
        let formatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.calendar = calendar
            formatter.calendar?.locale = locale
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .abbreviated
            return formatter
        }()
        return formatter.string(
            from: measurement.startDate,
            to: measurement.endDate
        ) ?? fallback
    }
    
}
