//
//  BlurredBackgroundViewModifier.swift
//  SpeedTest
//
//  Created by Antonio Pantaleo on 20/03/25.
//

import SwiftUI

extension View {
    func blurredBackground(_ color: NSColor) -> some View {
        self.modifier(BlurredBackgroundViewModifier(color: color))
    }
}

fileprivate struct BlurredBackgroundViewModifier: ViewModifier {
    
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

fileprivate struct VisualEffectView: NSViewRepresentable {
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
