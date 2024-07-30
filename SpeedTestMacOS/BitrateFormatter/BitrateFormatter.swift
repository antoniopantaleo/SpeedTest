//
//  BitrateFormatter.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 30/07/24.
//

import Foundation

protocol BitrateFormatter {
    var locale: Locale { get }
    func format(_ bits: Int) -> String
}
