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
    
    private(set) var value: CGFloat = 50
    private var cancellable: AnyCancellable?
    
    func startTimer() {
        cancellable = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()
            .sink { [weak self] _ in
                self?.value = CGFloat(Int.random(in: 0...100))
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
}
