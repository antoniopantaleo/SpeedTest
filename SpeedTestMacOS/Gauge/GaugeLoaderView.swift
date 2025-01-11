//
//  GaugeLoaderView.swift
//  SpeedTest
//
//  Created by Antonio Pantaleo on 30/11/24.
//

import SwiftUI

struct GaugeLoaderView: View {
    @State private var viewModel: GaugeViewModel
    
    init(viewModel: GaugeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
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
        .allowsHitTesting(false)
        .animation(.bouncy, value: viewModel.value)
        .gaugeStyle(SpeedometerGaugeStyle())
        .padding()
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
                
                Path { path in
                    let center = CGPoint(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    let diameter: CGFloat = geo.size.height / 10
                    path.addArc(
                        center: CGPoint(
                            x: center.x,
                            y: center.y + diameter / 2
                        ),
                        radius: diameter / 2,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360),
                        clockwise: true
                    )
                    path.move(to: CGPoint(
                        x: center.x + diameter / 2,
                        y: center.y + diameter / 2
                    ))
                    path.addLine(to: CGPoint(
                        x: center.x,
                        y: center.y - geo.size.height / 3.5
                    ))
                    path.addLine(to: CGPoint(
                        x: center.x - diameter / 2,
                        y: center.y + diameter / 2
                    ))
                }
                .foregroundStyle(.white.gradient)
                .rotationEffect(
                    .degrees(angle(configuration)),
                    anchor: .center
                )
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
#Preview("GaugeLoaderView") {
    GaugeLoaderView(
        viewModel: GaugeViewModel()
    )
}

#Preview("Moving GaugeLoaderView") {
    let viewModel = GaugeViewModel()
    GaugeLoaderView(
        viewModel: viewModel
    ).onAppear(perform: viewModel.startTimer)
}
#endif
