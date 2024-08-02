//
//  GaugeView.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 26/07/24.
//

import SwiftUI

struct GaugeView: View {
    
    private let purpleGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(
                    red: 207/255,
                    green: 150/255,
                    blue: 207/255
                ),
                Color(
                    red: 107/255,
                    green: 116/255,
                    blue: 179/255
                )
            ]
        ),
        startPoint: .trailing,
        endPoint: .leading
    )
    
    enum Amount {
        case low
        case medium
        case high
        
        var systemName: String {
            switch self {
            case .low:
                "gauge.with.dots.needle.bottom.0percent"
            case .medium:
                "gauge.with.dots.needle.bottom.50percent"
            case .high:
                "gauge.with.dots.needle.bottom.100percent"
            }
        }
    }
    
    let amount: Amount
    
    var body: some View {
        Image(systemName: amount.systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60)
            .foregroundStyle( purpleGradient)
    }
}

#Preview {
    GaugeView(amount: .low)
        .previewLayout(.sizeThatFits)
}
