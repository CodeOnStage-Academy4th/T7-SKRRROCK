//
//  AudioRecorder.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import AVFoundation
import SwiftUI

protocol AudioRecorder {
  var isRecording: Bool { get }

  func startRecording() throws
  func stopRecording() throws -> Data
}

enum AudioRecorderError: Error, LocalizedError {
  case audioRecorderNotAvailable
  case recordingIsAlreadyInProgress
  case recordingIsNotInProgress
}

class MockAudioRecorder: AudioRecorder {
  var isRecording: Bool = false

  func startRecording() throws {}

  func stopRecording() throws -> Data {
    return Data()
  }
}

@Observable
final class DefaultAudioRecorder: AudioRecorder {
  var isRecording: Bool {
    audioRecorder?.isRecording ?? false
  }

  private var audioRecorder: AVAudioRecorder?

  init() {
    self.audioRecorder = nil
  }

  func startRecording() throws {
    guard isRecording == false else {
      throw AudioRecorderError.recordingIsAlreadyInProgress
    }

    try configureAudioSessionForRecording()

    let audioFilename = "recording-\(Date().timeIntervalSince1970).m4a"
    let audioUrl = FileManager.default.temporaryDirectory
      .appendingPathComponent(audioFilename)

    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 44100,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
    ]

    audioRecorder = try AVAudioRecorder(
      url: audioUrl,
      settings: settings
    )

    guard let audioRecorder else {
      throw AudioRecorderError.audioRecorderNotAvailable
    }

    audioRecorder.record()
  }

  func stopRecording() throws -> Data {
    guard let audioRecorder else {
      throw AudioRecorderError.audioRecorderNotAvailable
    }

    guard isRecording == true else {
      throw AudioRecorderError.recordingIsNotInProgress
    }

    audioRecorder.stop()

    let audioUrl = audioRecorder.url

    let audioData = try Data(contentsOf: audioUrl)

    self.audioRecorder = nil

    return audioData
  }

  private func configureAudioSessionForRecording() throws {
    let session = AVAudioSession.sharedInstance()

    try session.setCategory(
      .playAndRecord,
      mode: .default,
      options: []
    )

    try session.setActive(true)
  }
}
