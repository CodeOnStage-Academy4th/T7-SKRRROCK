//
//  ShadowingRecordRepository.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftData

class ShadowingRecordRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    /// 성대모사 점수 저장
    func saveScore(userName: String, targetLearner: TargetLearner, finalScore: Int) throws {
        let record = ShadowingRecord(userName: userName, finalScore: finalScore, targetLearner: targetLearner)
        context.insert(record)
        try context.save()
    }
    
    /// 각 러너들의 성대모사 점수 불러오기
    func fetchScore(for targetLearner: TargetLearner) -> [ShadowingRecord] {
        return targetLearner.shadowingRecords.sorted { $0.finalScore > $1.finalScore }
    }
}
