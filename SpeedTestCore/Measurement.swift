//
//  Measurement.swift
//  SpeedTestCore
//
//  Created by Antonio on 25/07/24.
//

import Foundation

public struct Measurement {
    public let downlinkThroughput: Int
    public let uplinkThroughput: Int
    public let startDate: Date
    public let endDate: Date
    public let testEndpoint: URL
    public let osVersion: String
    
    init(
        downlinkThroughput: Int,
        uplinkThroughput: Int,
        startDate: Date,
        endDate: Date,
        testEndpoint: URL,
        osVersion: String
    ) {
        self.downlinkThroughput = downlinkThroughput
        self.uplinkThroughput = uplinkThroughput
        self.startDate = startDate
        self.endDate = endDate
        self.testEndpoint = testEndpoint
        self.osVersion = osVersion
    }
}
