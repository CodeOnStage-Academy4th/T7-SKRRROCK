//
//  AudioRecorder.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import Foundation

protocol AudioRecorder {
  var isRecording: Bool { get }

  func startRecording()
  func stopRecording() -> Data
}

class MockAudioRecorder: AudioRecorder {
  var isRecording: Bool = false

  func startRecording() {}

  func stopRecording() -> Data {
    return Data()
  }
}
