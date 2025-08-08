//
//  AudioPlayer.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import Foundation

protocol AudioPlayer {
  var isPlaying: Bool { get }

  func playAudio(audio: Data)
  func stopPlaying()
}

class MockAudioPlayer: AudioPlayer {
  private(set) var isPlaying: Bool = false

  func playAudio(audio _: Data) {}

  func stopPlaying() {}
}
