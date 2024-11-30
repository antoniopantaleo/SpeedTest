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
    init() {
        NSWindow.allowsAutomaticWindowTabbing = false
        viewModel = ViewModel(
            speedTester: NetworkQualitySpeedTester(
                shell: EnvironmentShell()
            ),
            bitrateFormatter: ByteCountBitrateFormatter()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .padding()
                .frame(width: 350, height: 500)
                .blurredBackground(.clear)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands{
            CommandGroup(replacing: .newItem) { @MainActor in
                let isLoading = viewModel.isLoading
                let action = isLoading ? viewModel.cancelRunningSpeedTest : viewModel.performSpeedTest
                Button(action: action) {
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
                            .credits: NSAttributedString(
                                string: "Hello world",
                                attributes: [
                                    .font: NSFont.boldSystemFont(
                                    ofSize: NSFont.smallSystemFontSize)
                                ]
                            ),
                            NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2024-2025 Antonio Pantaleo"
                        ]
                    )
                }
            }
        }
    }
}

struct BlurredBackgroundViewModifier: ViewModifier {
    
    private let color: NSColor
    
    init(color: NSColor) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                VisualEffectView(tintColor: color)
                    .ignoresSafeArea(.container, edges: .top)
            )
    }
}

extension View {
    func blurredBackground(_ color: NSColor) -> some View {
        self.modifier(BlurredBackgroundViewModifier(color: color))
    }
}

struct VisualEffectView: NSViewRepresentable {
    private let tintColor: NSColor
    
    init(tintColor: NSColor) {
        self.tintColor = tintColor
    }

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()

        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        visualEffectView.material = .underWindowBackground

        let tintView = NSView(frame: .zero)
        tintView.wantsLayer = true
        tintView.translatesAutoresizingMaskIntoConstraints = false

        visualEffectView.addSubview(tintView)

        NSLayoutConstraint.activate([
            tintView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            tintView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            tintView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            tintView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
        ])

        return visualEffectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        if let tintView = nsView.subviews.first {
            tintView.layer?.backgroundColor = tintColor.withAlphaComponent(0.1).cgColor
        }
    }
}
