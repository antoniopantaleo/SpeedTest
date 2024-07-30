//
//  SpeedTestMacOSApp.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 25/07/24.
//

import SwiftUI
import ShellKit
import SpeedTestCore
import TipKit

@main
struct SpeedTestMacOSApp: App {
    
    var body: some Scene {
        
        WindowGroup {
                Text("Hello world")
                .padding()
                .frame(width: 350, height: 500)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
