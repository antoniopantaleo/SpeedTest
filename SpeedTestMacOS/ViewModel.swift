//
//  ViewModel.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 30/07/24.
//

import Foundation
import SpeedTestCore

@Observable
final class ViewModel {
    
    private let speedTester: SpeedTester
    
    init(speedTester: SpeedTester) {
        self.speedTester = speedTester
    }
    
    enum State {
        case idle
        case loading
        case failure
    }
    
    private(set) var state: State = .idle
    private(set) var measurement: SpeedTestCore.Measurement?
    
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
