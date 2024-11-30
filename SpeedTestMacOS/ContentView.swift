//
//  ContentView.swift
//  SpeedTestMacOS
//
//  Created by Antonio on 25/07/24.
//

import SwiftUI
import SpeedTestCore

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

#if DEBUG
#Preview {
    let viewModel = ViewModel(
        speedTester: PreviewSpeedTester(latency: .exactely(5)),
        bitrateFormatter: ByteCountBitrateFormatter()
    )
    ContentView(viewModel: viewModel)       
}
#endif
