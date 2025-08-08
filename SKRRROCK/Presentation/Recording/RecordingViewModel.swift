//
//  RecordingViewModel.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

protocol RecordingViewModel {
  var isRecording: Bool { get }

  func startRecording()
  func stopRecording()
}

@Observable
class DefaultRecordingViewModel: RecordingViewModel {
  var isRecording: Bool {
    audioRecorder.isRecording
  }

  private let targetLearner: TargetLearner

  private let audioRecorder: AudioRecorder

  private let appCoordinator: AppCoordinator?

  init(targetLearner: TargetLearner, appCoordinator: AppCoordinator? = nil) {
    self.targetLearner = targetLearner

    self.audioRecorder = DefaultAudioRecorder()

    self.appCoordinator = appCoordinator
  }

  func startRecording() {
    do {
      try audioRecorder.startRecording()
    } catch {
      print("Failed to start recording: \(error)")
    }
  }

  func stopRecording() {
    do {
      try audioRecorder.stopRecording()
    } catch {
      print("Failed to stop recording: \(error)")
    }
  }
}
