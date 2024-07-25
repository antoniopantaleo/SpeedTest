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
}
