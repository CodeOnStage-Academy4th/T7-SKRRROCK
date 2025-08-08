//
//  RecordView.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

struct RecordingView: View {
    @State private var viewModel: RecordingViewModel

    init(viewModel: RecordingViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            ColorTokens.slate800
                .ignoresSafeArea()

            VStack(spacing: 128) {
                Text("똑같이 웃어보세요!")
                    .font(FontTokens.headingMdMedium)

                ZStack {
                    GradientLineCircle(size: 200, color: ColorTokens.slate800)

                    Circle()
                        .fill(ColorTokens.slate200.opacity(0.2))
                        .frame(maxHeight: 120)

                    Image(systemName: "mic")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 48, maxHeight: 48)
                }
                .onTapGesture {
                    viewModel.navigateToResult()
                }

                Text("웃음 녹음중...")
                    .font(FontTokens.headingSmRegular)
            }
            .foregroundStyle(ColorTokens.white)
        }
        .onAppear {
            viewModel.startRecording()
        }
        .onDisappear {
            viewModel.stopRecording()
        }
    }
}

#Preview {
    let gwangro = DefaultTargetLearner.gwangro
    let targetLearner = TargetLearner(name: gwangro.name, emoji: gwangro.emoji, laughAudioURL: gwangro.audioFileName)

    let viewModel = DefaultRecordingViewModel(targetLearner: targetLearner)

    RecordingView(viewModel: viewModel)
}
