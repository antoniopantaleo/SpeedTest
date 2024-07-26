//
//  NetworkQualitySpeedTestResult.swift
//  SpeedTestCore
//
//  Created by Antonio on 25/07/24.
//

import Foundation

struct NetworkQualitySpeedTestResult: Decodable {
    
    let dl_throughput: Int
    let ul_throughput: Int
    let start_date: String
    let end_date: String
    let test_endpoint: String
    let os_version: String

    var toMeasurement: SpeedTestCore.Measurement? {
        let dateFormatter: ISO8601DateFormatter = {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.formatOptions.insert(.withSpaceBetweenDateAndTime)
            dateFormatter.formatOptions.insert(.withFractionalSeconds)
            dateFormatter.formatOptions.remove(.withTimeZone)
            return dateFormatter
        }()
        guard
            let startDate = dateFormatter.date(from: start_date),
            let endDate = dateFormatter.date(from: end_date),
            let testEndpoint = URL(string: test_endpoint)
        else { return nil }
        return Measurement(
            downlinkThroughput: dl_throughput,
            uplinkThroughput: ul_throughput,
            startDate: startDate,
            endDate: endDate,
            testEndpoint: testEndpoint,
            osVersion: os_version
        )
    }
}
