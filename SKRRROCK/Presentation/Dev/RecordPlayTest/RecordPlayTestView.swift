//
//  RecordPlayTestView.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

struct RecordPlayTestView: View {
  @State private var viewModel: RecordPlayTestViewModel

  init(viewModel: RecordPlayTestViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      if viewModel.isRecording {
        stopRecordButton
      } else {
        startRecordButton
      }

      if viewModel.isPlaying {
        stopAudioButton
      } else {
        playAudioButton
      }
    }
  }

  private var startRecordButton: some View {
    Button("녹음 시작") {
      viewModel.startRecording()
    }
  }

  private var stopRecordButton: some View {
    Button("녹음 중지") {
      viewModel.stopRecording()
    }
  }

  private var playAudioButton: some View {
    Button("재생") {
      viewModel.playAudio()
    }
    .disabled(viewModel.isAudioAvailable == false)
  }

  private var stopAudioButton: some View {
    Button("중지") {
      viewModel.stopPlaying()
    }
  }
}

#Preview {
  let viewModel: RecordPlayTestViewModel = DefaultRecordPlayTestViewModel()

  RecordPlayTestView(viewModel: viewModel)
}
