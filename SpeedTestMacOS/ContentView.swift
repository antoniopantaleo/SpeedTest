//
//  ContentView.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 25/07/24.
//

import SwiftUI
#if DEBUG
@testable import SpeedTestCore
#else
import SpeedTestCore
#endif

struct ContentView: View {
    @State private var vm: ViewModel
    @State private var display = false
    @Namespace private var gauge
    @State private var homeAnimation: Bool = false
    
    
    init(viewModel: ViewModel) {
        _vm = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            switch vm.state {
            case .failure:
                Text("Something Failed")
                Button(action: vm.cancelRunningSpeedTest) {
                    Text("Try again")
                }
                .buttonStyle(.borderedProminent)
            case .idle, .loading:
                ZStack {
                    VStack {
                        if vm.measurement != nil {
                            ResultView(viewModel: $vm)
                        }
                        ContentUnavailableView(label: {
                            
                            Circle()
                                .stroke(lineWidth: 5)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.purple)
                                .blurredBackground(.purple)
                                .clipShape(Circle())
                                .shadow(radius: 8, y: 5)
                                .scaleEffect(vm.isLoading ? 11 : 1)
                            
                            .overlay {
                                Text("RUN")
                                    .shadow(
                                        radius: 8,
                                        y: 15
                                    )
                                    .blur(radius: vm.isLoading ? 10 : 0)
                                    .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                                    .opacity(vm.isLoading ? 0 : 1)
                                    .animation(.easeInOut.speed(0.5).delay(0.2), value: vm.isLoading)
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                vm.performSpeedTest()
                            }
                            
                            .frame(width: 130, height: 130)
                            Text("Speed Test")
                                .foregroundStyle(.primary)
                                .blur(radius: vm.isLoading ? 10 : 0)
                                .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                                .opacity(vm.isLoading ? 0 : 1)
                                .animation(.easeInOut.speed(0.5).delay(0.2), value: vm.isLoading)
                            
                            
                        }, description: {
                            Text("Run your first speed test and check your connection")
                                .padding(.bottom)
                                .blur(radius: vm.isLoading ? 10 : 0)
                                .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                                .opacity(vm.isLoading ? 0 : 1)
                                .animation(.easeInOut.speed(0.5).delay(0.2), value: vm.isLoading)
                            
                            Text("Checkout on **[GitHub](https://github.com/antoniopantaleo/SpeedTest)**")
                                .padding(.bottom)
                                .blur(radius: vm.isLoading ? 10 : 0)
                                .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                                .opacity(vm.isLoading ? 0 : 1)
                                .animation(.easeInOut.speed(0.5).delay(0.2), value: vm.isLoading)
                        }
                        )
                    }
                    .animation(.bouncy.speed(0.5), value: vm.isLoading)
                    
                    ZStack {
                        GaugeLoaderView()
                            .frame(width: 250, height: 230)
                            .padding(.horizontal)
                        Button(action: vm.cancelRunningSpeedTest) {
                            Text("Cancel")
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(.purple.gradient.opacity(0.5))
                                .clipShape(Capsule(style: .continuous))
                                .shadow(radius: 5)
                        }
                        .buttonStyle(.borderless)
                        .padding(.top, 230)
                    }
                    .scaleEffect(vm.isLoading ? 1 : 5)
                    .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                    .blur(radius: vm.isLoading ? 0 : 10)
                    .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                    .opacity(vm.isLoading ? 1 : 0)
                    .animation(.easeInOut.speed(0.5), value: vm.isLoading)
                }
                
            }
        }
    }
}

struct ResultView: View {
    
    @Binding var viewModel: ViewModel
    @State private var downloadText: String = "-"
    @State private var uploadText: String = "-"
    @State private var responsivenessText: String = "-"
    
    var body: some View {
        Grid {
            GridRow {
                VStack(alignment: .listRowSeparatorLeading) {
                    Label(
                        title: {
                            Text("Download")
                                .foregroundStyle(.secondary)
                        },
                        icon: {
                            Image(systemName: "arrow.down")
                                .foregroundStyle(.red.gradient)
                                .fontWeight(.semibold)
                        }
                    ).imageScale(.large)
                    
                    Text(downloadText)
                        .font(.title2)
                        .contentTransition(.numericText())
                        .onAppear {
                            withAnimation(.bouncy.speed(0.6).delay(0.2)) {
                                downloadText = viewModel.downloadBitrate
                            }
                        }
                }
                VStack(alignment: .listRowSeparatorLeading) {
                    Label(
                        title: {
                            Text("Upload")
                                .foregroundStyle(.secondary)
                        },
                        icon: {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.red.gradient)
                                .fontWeight(.semibold)
                        }
                    )
                    .imageScale(.large)
                    Text(uploadText)
                        .font(.title2)
                        .contentTransition(.numericText())
                        .onAppear {
                            withAnimation(.bouncy.speed(0.6).delay(0.2)) {
                                uploadText = viewModel.uploadBitrate
                            }
                        }
                }
            }
        }.padding()
    }
}

#if DEBUG
import ShellKit

fileprivate struct PreviewContentView: View {
    
    private let viewModel = ViewModel(
        speedTester: FakeSpeedTester(latency: .exactely(5)),
        bitrateFormatter: ByteCountBitrateFormatter()
    )
    var body: some View {
        ContentView(
            viewModel: viewModel
        )
    }
}

#Preview {
    PreviewContentView()
        .frame(width: 350, height: 500)

}

import Combine

@Observable
final class GaugeViewModel {
    
    private(set) var value: CGFloat = 100
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()
            .sink { [weak self] _ in
                self?.value = CGFloat(Int.random(in: 0...100))
            }
    }
    
}

fileprivate struct GaugeLoaderView: View {
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

struct SpeedometerGaugeStyle: GaugeStyle {

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

#Preview {
    GaugeLoaderView()
        
}

fileprivate class FakeSpeedTester: SpeedTester {
    
    enum Latency {
        case immediate
        case exactely(Int)
        case infinite
        
        var value: Int {
            switch self {
            case .immediate: 0
            case let .exactely(value): value
            case .infinite: Int.max
            }
        }
    }
    
    private let latency: Latency
    
    init(latency: Latency) {
        self.latency = latency
    }
    
    
    func performSpeedTest() async throws -> SpeedTestCore.Measurement {
        try await Task.sleep(for: .seconds(latency.value))
        return .init(
            downlinkThroughput: 543555550,
            uplinkThroughput: 15555340,
            startDate: .now,
            endDate: .now,
            testEndpoint: URL(string: "https://any-url.com")!,
            osVersion: "Version"
        )
    }
    
}
#endif
