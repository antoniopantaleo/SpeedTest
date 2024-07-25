//
//  SpeedTestCoreTests.swift
//  SpeedTestCoreTests
//
//  Created by Antonio on 25/07/24.
//

import XCTest
import ShellKit
import SpeedTestCore

final class SpeedTestCoreTests: XCTestCase {
    
    func test_succesfullyDecodes() async throws {
        let shell = FixedNetworkQualityShell()
        let sut = NetworkQualitySpeedTester(shell: shell)
        let result = try await sut.performSpeedTest()
        XCTAssertEqual(result.uplinkThroughput, 88208688)
        XCTAssertEqual(result.downlinkThroughput, 577723904)
        XCTAssertEqual(result.osVersion, "Version 14.5 (Build 23F79)")
        XCTAssertEqual(result.testEndpoint.absoluteString, "deber5-edge-bx-001.aaplimg.com")
        // TODO: test date
    }
    
    func test_failure() async {
        let shell = AlwaysFailingNetworkQualityShell()
        let sut = NetworkQualitySpeedTester(shell: shell)
        do {
            let result = try await sut.performSpeedTest()
            XCTFail("Expected to thow, got \(result) instead")
        } catch {}
    }
    
    // MARK: - Helpers
    
    private class AlwaysFailingNetworkQualityShell: Shell {
        func run(_ command: String...) async throws -> String {
            """
            {
              "end_date" : "2024-07-25 20:40:27.073",
              "error_code" : -1009,
              "error_domain" : "NSURLErrorDomain",
              "os_version" : "Version 14.5 (Build 23F79)",
              "other" : {

              },
              "start_date" : "2024-07-25 20:40:26.933"
            }
            """
        }
    }

    private class FixedNetworkQualityShell: Shell {
        func run(_ command: String...) async throws -> String {
            """
            {
              "base_rtt": 42,
              "dl_bytes_transferred": 663949500,
              "dl_flows": 12,
              "dl_throughput": 577723904,
              "end_date": "2024-07-25 20:28:59.456",
              "il_h2_req_resp": [],
              "il_tcp_handshake_443": [],
              "il_tls_handshake": [],
              "interface_name": "en1",
              "lud_foreign_h2_req_resp": [],
              "lud_foreign_tcp_handshake_443": [],
              "lud_foreign_tls_handshake": [],
              "lud_self_h2_req_resp": [],
              "os_version": "Version 14.5 (Build 23F79)",
              "other": {
                "ecn_values": {
                  "ecn_disabled": 255
                },
                "l4s_enablement": {
                  "disabled": 255
                },
                "protocols_seen": {
                  "h2": 255
                },
                "proxy_state": {
                  "not_proxied": 255
                }
              },
              "responsiveness": 541.19818115234375,
              "start_date": "2024-07-25 20:28:47.259",
              "test_endpoint": "deber5-edge-bx-001.aaplimg.com",
              "ul_bytes_transferred": 117913860,
              "ul_flows": 12,
              "ul_throughput": 88208688
            }
            """
        }
    }

    
}
