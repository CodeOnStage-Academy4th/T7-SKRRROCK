//
//  AudioPlayer.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import AVFoundation
import SwiftUI

protocol AudioPlayer {
  var isPlaying: Bool { get }

  func playAudio(audio: Data) throws
  func pausePlaying() throws
  func stopPlaying() throws
}

enum AudioPlayerError: Error {
  case audioRecorderNotAvailable
  case playingIsAlreadyInProgress
  case playingIsNotInProgress
}

class MockAudioPlayer: AudioPlayer {
  private(set) var isPlaying: Bool = false

  func playAudio(audio _: Data) throws {}

  func pausePlaying() throws {}

  func stopPlaying() throws {}
}

@Observable
final class DefaultAudioPlayer: NSObject, AudioPlayer, AVAudioPlayerDelegate {
  var isPlaying: Bool {
    audioPlayer?.isPlaying ?? false
  }

  private var audioPlayer: AVAudioPlayer?

  override init() {
    self.audioPlayer = nil

    super.init()
  }

  func playAudio(audio: Data) throws {
    try configureAudioSessionForPlaying()

    audioPlayer = try AVAudioPlayer(data: audio)

    guard let audioPlayer else {
      throw AudioPlayerError.audioRecorderNotAvailable
    }

    audioPlayer.delegate = self
    audioPlayer.play()
  }

  func audioPlayerDidFinishPlaying(
    _ player: AVAudioPlayer,
    successfully flag: Bool
  ) {
    self.audioPlayer = nil
  }

  func pausePlaying() throws {
    guard isPlaying == true else {
      throw AudioPlayerError.playingIsNotInProgress
    }

    guard let audioPlayer else {
      throw AudioPlayerError.audioRecorderNotAvailable
    }

    audioPlayer.pause()
  }

  func stopPlaying() throws {
    guard isPlaying == true else {
      throw AudioPlayerError.playingIsNotInProgress
    }

    guard let audioPlayer else {
      throw AudioPlayerError.audioRecorderNotAvailable
    }

    audioPlayer.stop()

    self.audioPlayer = nil
  }

  private func configureAudioSessionForPlaying() throws {
    let session = AVAudioSession.sharedInstance()

    try session.setCategory(.playback, mode: .default, options: [])

    try session.setActive(true)
  }
}
