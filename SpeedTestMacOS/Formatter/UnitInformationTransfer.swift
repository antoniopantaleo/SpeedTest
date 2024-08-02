//
//  UnitInformationTransfer.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 26/07/24.
//

import Foundation

fileprivate class UnitInformationTransferConverter: UnitConverter {
    
    private let unitInformationStorage: UnitInformationStorage
    
    init(_ unitInformationStorage: UnitInformationStorage) {
        self.unitInformationStorage = unitInformationStorage
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        unitInformationStorage.converter.baseUnitValue(fromValue: value)
    }
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        unitInformationStorage.converter.value(fromBaseUnitValue: baseUnitValue)
    }
}

public class UnitInformationTransfer: Dimension {
    
    static let bitsPerSeconds = UnitInformationTransfer(symbol: "bps", .bits)
    static let kilobitsPerSeconds = UnitInformationTransfer(symbol: "kbps", .kilobits)
    static let kibibitsPerSeconds = UnitInformationTransfer(symbol: "Kibps", .kibibits)
    static let megabitsPerSeconds = UnitInformationTransfer(symbol: "Mbps", .megabits)
    static let gigabitsPerSeconds = UnitInformationTransfer(symbol: "Gbps", .gigabits)
    static let terabitsPerSeconds = UnitInformationTransfer(symbol: "Tbps", .terabits)
    static let petabitsPerSeconds = UnitInformationTransfer(symbol: "Pbps", .petabits)
    static let exabitsPerSeconds = UnitInformationTransfer(symbol: "Ebps", .exabits)
    static let zettabitsPerSeconds = UnitInformationTransfer(symbol: "Zbps", .zettabits)
    static let yottabitsPerSeconds = UnitInformationTransfer(symbol: "Ybps", .yottabits)
    
    public override class func baseUnit() -> Self {
        Self.bitsPerSeconds as! Self
    }

    override init(
        symbol: String,
        converter: UnitConverter
    ) {
        super.init(symbol: symbol, converter: converter)
    }
    
    private convenience init(symbol: String, _ unitInformationStorage: UnitInformationStorage) {
        self.init(
            symbol: symbol,
            converter: UnitInformationTransferConverter(unitInformationStorage)
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}
