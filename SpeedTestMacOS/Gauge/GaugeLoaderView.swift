//
//  GaugeLoaderView.swift
//  SpeedTest
//
//  Created by Antonio Pantaleo on 30/11/24.
//

import SwiftUI

struct GaugeLoaderView: View {
    @State private var viewModel = GaugeViewModel()
    
    var body: some View {
        VStack {
            Gauge(
                value: viewModel.value,
                in: 0...100,
                label: {
                    Text("Mb/s")
                },
                currentValueLabel: {
                    Text(viewModel.value, format: .number)
                        .contentTransition(.numericText())
                }
            )
            .animation(.bouncy, value: viewModel.value)
            .gaugeStyle(SpeedometerGaugeStyle())
            .padding()
        }
        
    }
}

fileprivate struct SpeedometerGaugeStyle: GaugeStyle {

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        .quaternary,
                        style: StrokeStyle(
                            lineWidth: geo.size.height / 20,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(135))
                Circle()
                    .trim(from: 0, to: 0.75 * configuration.value)
                    .stroke(
                        .purple.gradient.opacity(0.5),
                        style: StrokeStyle(
                            lineWidth: geo.size.height / 20,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(135))
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        Color.white,
                        style: StrokeStyle(
                            lineWidth: geo.size.height / 30,
                            lineCap: .butt,
                            lineJoin: .round,
                            dash: [1, geo.size.height / 3],
                            dashPhase: 1
                        )
                    )
                    .rotationEffect(.degrees(135))
                
                Capsule()
                    .frame(
                        width: 10,
                        height: geo.size.height / 3.5
                    )
                    .rotationEffect(
                        .degrees(angle(configuration)),
                        anchor: .bottom
                    )
                    .padding(.bottom, geo.size.height / 4)
            }
            .position(
                x: geo.frame(in: .local).midX,
                y: geo.frame(in: .local).midY
            )
        }
    }
    
    private func angle(_ configuration: GaugeStyleConfiguration) -> Double {
        let offset = 135.0
        return (configuration.value * 270) - offset
    }

}

#if DEBUG
#Preview {
    GaugeLoaderView()
}
#endif
