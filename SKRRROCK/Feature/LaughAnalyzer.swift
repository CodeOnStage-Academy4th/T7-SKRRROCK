//
//  LaughAnalyzer.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import Foundation

protocol LaughAnalyzer {
  func compareAudioSimilarity(orginal: Data, target: Data) -> Float
}

class MockLaughAnalyzer: LaughAnalyzer {
  func compareAudioSimilarity(orginal _: Data, target _: Data) -> Float {
    return .zero
  }
}
