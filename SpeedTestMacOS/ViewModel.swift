//
//  ViewModel.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 30/07/24.
//

import Foundation

@Observable
final class ViewModel {
    
    enum State {
        case idle
    }
    
    private(set) var state: State = .idle
    
}
