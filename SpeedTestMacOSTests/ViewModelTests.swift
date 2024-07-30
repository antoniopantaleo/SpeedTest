//
//  ViewModelTests.swift
//  ViewModelTests
//
//  Created by Antonio on 30/07/24.
//

import XCTest
@testable import SpeedTestCore
@testable import SpeedTestMacOS

final class ViewModelTests: XCTestCase {
    
    func test_init_initialStateIsIdle() {
        // Given
        let (sut, _) = makeSUT()
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_performSpeedTest_changeStateToLoading() {
        // Given
        let (sut, _) = makeSUT()
        // When
        sut.performSpeedTest()
        // Then
        XCTAssertEqual(sut.state, .loading)
    }
    
    func test_performSpeedTest_changeStateBackToIdleOnSuccesfulSpeedTest() async {
        // Given
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        await spy.complete(with: .success(anyMeasurement))
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
    
    //MARK: Helpers
    
    private func makeSUT() -> (sut: ViewModel, speedTester: SpeedTesterSpy) {
        let spy = SpeedTesterSpy()
        let sut = ViewModel(speedTester: spy)
        return (sut, spy)
    }
    
    private var anyMeasurement: SpeedTestCore.Measurement {
        .init(
            downlinkThroughput: 10,
            uplinkThroughput: 10,
            startDate: .now,
            endDate: .now.addingTimeInterval(3600),
            testEndpoint: URL(string: "http://any-url.com")!,
            osVersion: "any os version"
        )
    }
    
    private final class SpeedTesterSpy: SpeedTester {
        
        private var continuation: UnsafeContinuation<SpeedTestCore.Measurement, Error>?
        
        func performSpeedTest() async throws -> SpeedTestCore.Measurement {
            return try await withUnsafeThrowingContinuation { continuation in
                self.continuation = continuation
            }
        }
        
        func complete(with result: Result<SpeedTestCore.Measurement, Error>) async {
            await synchronized {
                continuation?.resume(with: result)
                continuation = nil
            }
        }
        
        private func synchronized(_ block: () -> Void) async {
            let duration = Duration.milliseconds(1)
            try? await Task.sleep(for: duration)
            block()
            try? await Task.sleep(for: duration)
        }
    }
    
}
