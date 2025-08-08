//
//  TargetLearner.swift
//  SKRRROCK
//
//  Created by Jun on 8/8/25.
//

import Foundation
import SwiftData

/// 성대모사를 당하는 타켓 유저입니다. 유저는 TargetLearner의 웃음소리를 쉐도잉합니다.
@Model
class TargetLearner {
    var id: UUID
    var name: String // 광로, 세나
    var emoji: String
    var laughAudioURL: String // gwanro_laugh.m4a
    var laughAudioData: Data? {
        guard let url = Bundle.main.url(forResource: laughAudioURL, withExtension: nil) else { return nil }
        return try? Data(contentsOf: url)
    }
    
    init(name: String, emoji: String, laughAudioURL: String) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.laughAudioURL = laughAudioURL
    }
}
