//
//  ViewModelTests.swift
//  ViewModelTests
//
//  Created by Antonio on 30/07/24.
//

import XCTest
@testable import SpeedTestMacOS

final class ViewModelTests: XCTestCase {
    
    func test_init_initialStateIsIdle() {
        // Given
        let sut = ViewModel()
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
    
}

