//
//  FakeSpeedTester.swift
//  SpeedTest
//
//  Created by Antonio Pantaleo on 30/11/24.
//


#if DEBUG
import Foundation
@testable import SpeedTestCore
import ShellKit

final class FakeSpeedTester: SpeedTester {
    
    enum Latency {
        case immediate
        case exactely(Int)
        case infinite
        
        var value: Int {
            switch self {
            case .immediate: 0
            case let .exactely(value): value
            case .infinite: Int.max
            }
        }
    }
    
    private let latency: Latency
    
    init(latency: Latency) {
        self.latency = latency
    }
    
    func performSpeedTest() async throws -> SpeedTestCore.Measurement {
        try await Task.sleep(for: .seconds(latency.value))
        return .init(
            downlinkThroughput: 543555550,
            uplinkThroughput: 15555340,
            startDate: .now,
            endDate: .now,
            testEndpoint: URL(string: "https://any-url.com")!,
            osVersion: "Version"
        )
    }
    
}
#endif
