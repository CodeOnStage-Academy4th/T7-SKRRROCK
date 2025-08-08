//
//  ResultViewModel.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftUI

protocol ResultViewModel {

}

@Observable
class DefaultResultViewModel: ResultViewModel {
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

