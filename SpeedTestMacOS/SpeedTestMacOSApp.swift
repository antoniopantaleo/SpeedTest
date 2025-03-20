//
//  SpeedTestMacOSApp.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 25/07/24.
//

import SwiftUI
import ShellKit
import SpeedTestCore

@main
struct SpeedTestMacOSApp: App {
    private let viewModel: ViewModel
    private let loaderViewModel: GaugeViewModel
    
    init() {
        NSWindow.allowsAutomaticWindowTabbing = false
        viewModel = ViewModel(
            speedTester: NetworkQualitySpeedTester(
                shell: EnvironmentShell()
            ),
            bitrateFormatter: ByteCountBitrateFormatter()
        )
        loaderViewModel = GaugeViewModel()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: viewModel,
                loaderViewModel: loaderViewModel
            )
                .padding()
                .frame(width: 350, height: 500)
                .blurredBackground(.clear)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands{
            CommandGroup(replacing: .newItem) { @MainActor in
                let isLoading = viewModel.isLoading
                Button(action: {
                    if isLoading {
                        loaderViewModel.stopTimer()
                        viewModel.cancelRunningSpeedTest()
                    } else  {
                        loaderViewModel.startTimer()
                        viewModel.performSpeedTest()
                    }
                }) {
                    isLoading ? Text("Cancel") : Text("Run")
                }
                .keyboardShortcut(isLoading ? "." : "R", modifiers: [.command])
            }
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About SpeedTest") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2024-2025 Antonio Pantaleo"
                        ]
                    )
                }
            }
        }
    }
}
