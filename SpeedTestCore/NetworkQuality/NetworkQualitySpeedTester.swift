//
//  NetworkQualitySpeedTester.swift
//  SpeedTestCore
//
//  Created by Antonio on 25/07/24.
//

import Foundation
import ShellKit

public final class NetworkQualitySpeedTester: SpeedTester {
    private let shell: Shell
    
    public init(shell: Shell) {
        self.shell = shell
    }
    
    private let genericError = NSError(domain: "Generic error", code: 0)
    
    public func performSpeedTest() async throws -> SpeedTestCore.Measurement {
        let results = try await shell.run("networkQuality", "-c")
        guard let jsonData = results.data(using: .utf8) else { throw genericError }
        let res = try JSONDecoder().decode(NetworkQualitySpeedTestResult.self, from: jsonData)
        guard let mes = res.toMeasurement else { throw genericError }
        return mes
    }
}
