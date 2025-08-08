//
//  ShadowingRecord.swift
//  SKRRROCK
//
//  Created by Jun on 8/8/25.
//

import Foundation
import SwiftData

@Model
class ShadowingRecord {
    var id: UUID
    var userName: String // 사용자 이름
    var finalScore: Int
    var targetLearner: TargetLearner // 어떤 러너의 웃음을 따라하였는가?
    
    init(userName: String, finalScore: Int, targetLearner: TargetLearner) {
        self.id = UUID()
        self.userName = userName
        self.finalScore = finalScore
        self.targetLearner = targetLearner
    }
}
