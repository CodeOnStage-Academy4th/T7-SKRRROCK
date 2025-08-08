//
//  RecordViewModel.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

protocol RecordViewModel {
  var isRecording: Bool { get }

  func startRecording()
  func stopRecording()
}

@Observable
class DefaultRecordViewModel: RecordViewModel {
  var isRecording: Bool {
    audioRecorder.isRecording
  }

  private let audioRecorder: AudioRecorder

  init(audioRecorder: AudioRecorder) {
    self.audioRecorder = audioRecorder
  }

  func startRecording() {}
  func stopRecording() {}
}
