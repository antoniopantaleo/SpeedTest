//
//  ContentView.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 25/07/24.
//

import SwiftUI
import SpeedTestCore

struct ContentView: View {
    @State private var viewModel: ViewModel
    @State private var loaderViewModel: GaugeViewModel
    @State private var display = false
    @State private var homeAnimation: Bool = false
    
    init(viewModel: ViewModel, loaderViewModel: GaugeViewModel) {
        _viewModel = State(initialValue: viewModel)
        _loaderViewModel = State(initialValue: loaderViewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                VStack {
                    if case let .failure(message) = viewModel.state {
                        Text(message)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 3)
                            .containerRelativeFrame(.horizontal) { value, _ in
                                value
                            }
                            .frame(minHeight: 50)
                            .background(.pink.secondary)
                        Spacer()
                    } else if viewModel.measurement != nil {
                        ResultView(viewModel: $viewModel)
                    }
                    ContentUnavailableView(label: {
                        Circle()
                            .stroke(lineWidth: 5)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.purple)
                            .blurredBackground(.purple)
                            .clipShape(Circle())
                            .shadow(radius: 8, y: 5)
                            .scaleEffect(viewModel.isLoading ? 11 : 1)
                        
                            .overlay {
                                Text("RUN")
                                    .foregroundStyle(.purple)
                                    .fontWeight(.bold)
                                    .shadow(
                                        radius: 8,
                                        y: 15
                                    )
                                    .blur(radius: viewModel.isLoading ? 10 : 0)
                                    .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
                                    .opacity(viewModel.isLoading ? 0 : 1)
                                    .animation(.easeInOut.speed(0.5).delay(0.2), value: viewModel.isLoading)
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                loaderViewModel.startTimer()
                                viewModel.performSpeedTest()
                            }
                            .frame(width: 130, height: 130)
                            .padding(.bottom)
                        Text("SpeedTest")
                            .foregroundStyle(.primary)
                            .blur(radius: viewModel.isLoading ? 10 : 0)
                            .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
                            .opacity(viewModel.isLoading ? 0 : 1)
                            .animation(.easeInOut.speed(0.5).delay(0.2), value: viewModel.isLoading)
                        
                        
                    }, description: {
                        Text("Run your first speed test and check your connection")
                            .padding(.bottom)
                            .blur(radius: viewModel.isLoading ? 10 : 0)
                            .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
                            .opacity(viewModel.isLoading ? 0 : 1)
                            .animation(.easeInOut.speed(0.5).delay(0.2), value: viewModel.isLoading)
                        
                        Text("Checkout on **[GitHub](https://github.com/antoniopantaleo/SpeedTest)**")
                            .padding(.bottom)
                            .blur(radius: viewModel.isLoading ? 10 : 0)
                            .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
                            .opacity(viewModel.isLoading ? 0 : 1)
                            .animation(.easeInOut.speed(0.5).delay(0.2), value: viewModel.isLoading)
                    }
                    )
                }
                .animation(.bouncy.speed(0.5), value: viewModel.isLoading)
                
                ZStack {
                    GaugeLoaderView(viewModel: loaderViewModel)
                        .frame(width: 250, height: 230)
                        .padding(.horizontal)
                    Button(action: {
                        loaderViewModel.stopTimer()
                        viewModel.cancelRunningSpeedTest()
                    }
                    ) {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.purple.gradient.opacity(0.5))
                            .clipShape(Capsule(style: .continuous))
                            .shadow(radius: 5)
                    }
                    .buttonStyle(.borderless)
                    .padding(.top, 230)
                }
                .scaleEffect(viewModel.isLoading ? 1 : 5)
                .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
                .blur(radius: viewModel.isLoading ? 0 : 10)
                .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut.speed(0.5), value: viewModel.isLoading)
            }
        }
    }
}

#if DEBUG
#Preview("Success") {
    let viewModel = ViewModel(
        speedTester: PreviewSpeedTester(
            latency: .exactely(3),
            outcome: .success
        ),
        bitrateFormatter: ByteCountBitrateFormatter()
    )
    let loaderViewModel = GaugeViewModel()
    ContentView(
        viewModel: viewModel,
        loaderViewModel: loaderViewModel
    )
}

#Preview("Error") {
    let viewModel = ViewModel(
        speedTester: PreviewSpeedTester(
            latency: .exactely(3),
            outcome: .error
        ),
        bitrateFormatter: ByteCountBitrateFormatter()
    )
    let loaderViewModel = GaugeViewModel()
    ContentView(
        viewModel: viewModel,
        loaderViewModel: loaderViewModel
    )
}
#endif
