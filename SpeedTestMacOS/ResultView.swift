//
//  ResultView.swift
//  SpeedTest
//
//  Created by Antonio Pantaleo on 30/11/24.
//

import SwiftUI

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
                            Text("MAIN.DOWNLOAD")
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
                            Text("MAIN.UPLOAD")
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
#Preview {
    @Previewable @State var viewModel = ViewModel(
        speedTester: PreviewSpeedTester(
            latency: .immediate,
            outcome: .success
        ),
        bitrateFormatter: ByteCountBitrateFormatter()
    )
    ResultView(viewModel: $viewModel)
        .onAppear(perform: viewModel.performSpeedTest)
}
#endif
