//
//  PersonalPageViewModel.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

protocol PersonalPageViewModel {
  var targetLearner: TargetLearner { get }
  var sortedRecords: [ShadowingRecord] { get }
  var isPlaying: Bool { get }
  
  func playAudio()
  func navigateToRecording()
}

@Observable
final class DefaultPersonalPageViewModel: PersonalPageViewModel {
  let targetLearner: TargetLearner
  var sortedRecords: [ShadowingRecord] {
    Array(targetLearner.shadowingRecords.sorted { $0.finalScore > $1.finalScore }.prefix(5))
  }
  var isPlaying: Bool {
    audioPlayer.isPlaying
  }
  
  private let audioPlayer: AudioPlayer
  
  private let appCoordinator: AppCoordinator?
  
  init(targetLearner: TargetLearner, appCoordinator: AppCoordinator? = nil) {
    self.targetLearner = targetLearner
    
    self.audioPlayer = DefaultAudioPlayer()
    
    self.appCoordinator = appCoordinator
  }
  
  func playAudio() {
    guard let audioData = targetLearner.laughAudioData else { return }
    
    do {
      try audioPlayer.playAudio(audio: audioData)
    } catch {
      print("Failed to play audio: \(error)")
    }
  }
  
  func navigateToRecording() {
    appCoordinator?.push(.recording(targetLearner))
  }
}
