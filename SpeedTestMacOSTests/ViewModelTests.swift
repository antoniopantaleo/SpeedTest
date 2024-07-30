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
    
    func test_performSpeedTest_changeStateToFailureOnFailingSpeedTest() async {
        // Given
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        await spy.complete(with: .failure(anyError))
        // Then
        XCTAssertEqual(sut.state, .failure)
    }
    
    func test_cancelSpeedTest_changesStateBackToIdle() async {
        // Given
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        sut.cancelRunningSpeedTest()
        await spy.complete(with: .success(anyMeasurement))
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_cancelSpeedTest_doesNotUpdateMeasurementAfterCompletion() async {
        // Given
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        sut.cancelRunningSpeedTest()
        await spy.complete(with: .success(anyMeasurement))
        // Then
        XCTAssertNil(sut.measurement)
    }
    
    func test_performSpeedTest_afterCancellation_updatesMeasurement() async {
        // Given
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        sut.cancelRunningSpeedTest()
        await spy.complete(with: .success(anyMeasurement))
        sut.performSpeedTest()
        await spy.complete(with: .success(anyMeasurement))
        // Then
        XCTAssertNotNil(sut.measurement)
    }
    
    func test_performSpeedTest_savesMeasurementAfterSuccessfullSpeedTest() async {
        // Given
        let startDate = Date()
        let endDate = Date().addingTimeInterval(3600)
        let givenMeasurement = SpeedTestCore.Measurement(
            downlinkThroughput: 150,
            uplinkThroughput: 200,
            startDate: startDate,
            endDate: endDate,
            testEndpoint: URL(string: "any.test.endpoint")!,
            osVersion: "any version"
        )
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        await spy.complete(with: .success(givenMeasurement))
        // Then
        XCTAssertEqual(sut.measurement?.downlinkThroughput, 150)
        XCTAssertEqual(sut.measurement?.uplinkThroughput, 200)
        XCTAssertEqual(sut.measurement?.startDate, startDate)
        XCTAssertEqual(sut.measurement?.endDate, endDate)
        XCTAssertEqual(sut.measurement?.testEndpoint, URL(string: "any.test.endpoint"))
        XCTAssertEqual(sut.measurement?.osVersion, "any version")
    }
    
    func test_elapsedTime_doesNotRenderForNoMeasurement() async {
        // Given
        let (sut, _) = makeSUT()
        // Then
        XCTAssertEqual(sut.speedTestTime(), "-")
    }
    
    func test_elapsedTime_rendersCorrectly() async {
        // Given
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "it_IT")
        let startDate = Date()
        let fiveMinutesAndThirtySeconds: TimeInterval = 60 * 5 + 30
        let endDate = Date().addingTimeInterval(fiveMinutesAndThirtySeconds)
        let givenMeasurement = SpeedTestCore.Measurement(
            downlinkThroughput: 150,
            uplinkThroughput: 200,
            startDate: startDate,
            endDate: endDate,
            testEndpoint: anyUrl,
            osVersion: anyOSVersion
        )
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        await spy.complete(with: .success(givenMeasurement))
        // Then
        XCTAssertEqual(
            sut.speedTestTime(
                calendar: calendar, 
                locale: locale
            ), "5 min 30 s"
        )
    }
    
    func test_measurementBitrate_rendersCorrectly() async {
        // Given
        let givenMeasurement = SpeedTestCore.Measurement(
            downlinkThroughput: 1024 * 1_000_000,
            uplinkThroughput: 200,
            startDate: anyDate,
            endDate: anyDate,
            testEndpoint: anyUrl,
            osVersion: anyOSVersion
        )
        let (sut, spy) = makeSUT()
        // When
        sut.performSpeedTest()
        await spy.complete(with: .success(givenMeasurement))
        // Then
        XCTAssertEqual(sut.downloadBitrate, "1,02 Gb/s")
        XCTAssertEqual(sut.uploadBitrate, "200 b/s")
    }
    
    //MARK: Helpers
    
    private func makeSUT() -> (sut: ViewModel, speedTester: SpeedTesterSpy) {
        let spy = SpeedTesterSpy()
        let sut = ViewModel(
            speedTester: spy,
            bitrateFormatter: ByteCountBitrateFormatter(
                locale: Locale(identifier: "it_IT")
            )
        )
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
    
    private var anyError: Error {
        NSError(domain: "any error", code: 0)
    }
    
    private var anyDate: Date { Date() }
    private var anyOSVersion: String { "any os vesrion" }
    private var anyUrl: URL { URL(string: "any.url.com")!}
    
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
