//
//  RecordPlayTestViewModel.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

protocol RecordPlayTestViewModel {
  var isRecording: Bool { get }
  var isPlaying: Bool { get }
  var isAudioAvailable: Bool { get }

  func startRecording()
  func stopRecording()
  func playAudio()
  func stopPlaying()
}

@Observable
final class DefaultRecordPlayTestViewModel: RecordPlayTestViewModel {
  var isRecording: Bool {
    audioRecorder.isRecording
  }
  var isPlaying: Bool {
    audioPlayer.isPlaying
  }
  var isAudioAvailable: Bool {
    audioData != nil
  }

  private var audioData: Data?

  private let audioRecorder: AudioRecorder
  private let audioPlayer: AudioPlayer

  init() {
    self.audioData = nil

    self.audioRecorder = DefaultAudioRecorder()
    self.audioPlayer = DefaultAudioPlayer()
  }

  func startRecording() {
    do {
      try audioRecorder.startRecording()
    } catch {
      print("Failed to start recording.")
    }
  }

  func stopRecording() {
    do {
      audioData = try audioRecorder.stopRecording()
    } catch {
      print("Failed to stop recording.")
    }
  }

  func playAudio() {
    do {
      guard let audioData else { return }

      try audioPlayer.playAudio(audio: audioData)
    } catch {
      print("Failed to play audio.")
    }
  }
  func stopPlaying() {
    do {
      try audioPlayer.stopPlaying()
    } catch {
      print("Failed to stop audio.")
    }
  }
}
