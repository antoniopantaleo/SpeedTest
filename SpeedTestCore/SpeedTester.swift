//
//  SpeedTester.swift
//  SpeedTestCore
//
//  Created by Antonio on 25/07/24.
//

import Foundation

public protocol SpeedTester {
    func performSpeedTest() async throws -> SpeedTestCore.Measurement
}
