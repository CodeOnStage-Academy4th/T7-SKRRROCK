//
//  TargetLearnerManager.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftData

class TargetLearnerManager {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    static func setupDefaultLearners(context: ModelContext) {
        let descriptor = FetchDescriptor<TargetLearner>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        if existingCount == 0 {
            for defaultLearner in DefaultTargetLearner.allCases {
                let targetLearner = TargetLearner(
                    name: defaultLearner.name,
                    emoji: defaultLearner.emoji,
                    laughAudioURL: defaultLearner.audioFileName
                )
                context.insert(targetLearner)
            }
            
            do {
                try context.save()
                print("기본 TargetLearner 4명 (광로, 세나, 에디, 체리)이 생성되었습니다")
            } catch {
                print("TargetLearner 생성 실패: \(error)")
            }
        }
    }
    
    func fetchAllTargetLearners() -> [TargetLearner] {
        let descriptor = FetchDescriptor<TargetLearner>()
        return (try? context.fetch(descriptor)) ?? []
    }
}
