//
//  ResultViewModel.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftUI

protocol ResultViewModel {
    var score: Int { get set }
    var targetLearnerName: String { get set }
    func getFirstMessage() -> String
    func getSecondMessage() -> String
    func getDanceImageName() -> String
}

@Observable
class DefaultResultViewModel: ResultViewModel {
    var score = 0
    var targetLearnerName: String = ""

    func getFirstMessage() -> String {
        switch score {
        case 100:
            return "완전 똑같은데?"
        case 90...99:
            return "웃음이 너~무 똑같아서"
        case 80...89:
            return "\(targetLearnerName)이 완~전 심쿵!"
        case 70...79:
            return "피치 Good~ 성량 Good~"
        case 60...69:
            return "성의는 백점 웃음은 좀 더~"
        case 50...59:
            return "웃기만 하고"
        case 40...49:
            return "너~~어 이 웃음에 조금만 더 집! 중!"
        case 30...39:
            return "토닥토닥~😇"
        case 20...29:
            return "이 점수 진짜 어쩌면 좋지?"
        case 10...19:
            return "점수 따위 상관없이"
        default:
            return "다음엔 더 잘할 수 있어요!"
        }
    }

    func getSecondMessage() -> String {
        switch score {
        case 100:
            return "당신 혹시 \(targetLearnerName)아니세요?"
        case 90...99:
            return "\(targetLearnerName)이 기절!"
        case 80...89:
            return "정말 멋져요잉"
        case 70...79:
            return "아~주 똑같아요😁"
        case 60...69:
            return ""
        case 50...59:
            return "웃음은 안 따라할끼니?"
        case 40...49:
            return ""
        case 30...39:
            return "다음 웃음은 100점 가보즈아~!"
        case 20...29:
            return "모르게쒀요~"
        case 10...19:
            return "웃는다고 전해라~"
        default:
            return "포기하지 말고 다시 도전!"
        }
    }
    
    func getDanceImageName() -> String {
        let learnerMapping: [String: String] = [
            "광로": "gwangro",
            "세나": "sena",
            "에디": "eddey",
            "체리": "cherry"
        ]

        if let rawValue = learnerMapping[targetLearnerName] {
            return "\(rawValue)_dance"
        }

        return "dance_1"
    }
}
