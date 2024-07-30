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
    
    func performSpeedTest() {
        state = .loading
        Task {
            do {
                let measurement = try await speedTester.performSpeedTest()
                self.measurement = measurement
                state = .idle
            } catch {
                state = .failure
            }
        }
    }
    
}
