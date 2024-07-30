//
//  ByteCountBitrateFormatter.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 30/07/24.
//

import Foundation

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
