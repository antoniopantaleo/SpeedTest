//
//  GaugeViewModel.swift
//  SpeedTest
//
//  Created by Antonio Pantaleo on 30/11/24.
//

import Foundation
import Combine

@Observable
final class GaugeViewModel {
    
    private(set) var value: CGFloat = 100
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()
            .sink { [weak self] _ in
                self?.value = CGFloat(Int.random(in: 0...100))
            }
    }
    
}
