//
//  ResultViewModel.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Accelerate
import Foundation
import SwiftData
import SwiftUI

struct ResultViewData: Hashable {
    let targetLearner: TargetLearner
    let audioData: Data
}

protocol ResultViewModel {
    var isLoading: Bool { get }
    var score: Int { get }
    var targetLearnerName: String { get }
    var isShowingNicknameInput: Bool { get }
    var nickname: String { get }

    func getFirstMessage() -> String
    func getSecondMessage() -> String
    func getDanceImageName() -> String

    func retry()

    func setIsShowingNicknameInput(_ isShowingNicknameInput: Bool)
    func setNickname(_ nickname: String)
    func analyzeRecord()
    func uploadScore(_ context: ModelContext)
}

@Observable
class DefaultResultViewModel: ResultViewModel {
    private(set) var isLoading: Bool
    private(set) var score: Int
    private(set) var targetLearnerName: String
    private(set) var isShowingNicknameInput: Bool
    private(set) var nickname: String

    private let resultViewData: ResultViewData

    private let appCoordinator: AppCoordinator?

    private let analyzer: LaughAnalyzerDev = .init()

    init(resultViewData: ResultViewData, appCoordinator: AppCoordinator? = nil) {
        isLoading = false
        score = 0
        targetLearnerName = resultViewData.targetLearner.name
        isShowingNicknameInput = false
        nickname = ""

        self.resultViewData = resultViewData

        self.appCoordinator = appCoordinator
    }

    func getFirstMessage() -> String {
        switch score {
        case 100:
            return "완전 똑같은데?"
        case 90 ... 99:
            return "웃음이 너~무 똑같아서"
        case 80 ... 89:
            return "\(targetLearnerName)이 완~전 심쿵!"
        case 70 ... 79:
            return "피치 Good~ 성량 Good~"
        case 60 ... 69:
            return "성의는 백점 웃음은 좀 더~"
        case 50 ... 59:
            return "웃기만 하고"
        case 40 ... 49:
            return "너~~어 이 웃음에 조금만 더 집! 중!"
        case 30 ... 39:
            return "토닥토닥~😇"
        case 20 ... 29:
            return "이 점수 진짜 어쩌면 좋지?"
        case 10 ... 19:
            return "점수 따위 상관없이"
        default:
            return "다음엔 더 잘할 수 있어요!"
        }
    }

    func getSecondMessage() -> String {
        switch score {
        case 100:
            return "당신 혹시 \(targetLearnerName)아니세요?"
        case 90 ... 99:
            return "\(targetLearnerName)이 기절!"
        case 80 ... 89:
            return "정말 멋져요잉"
        case 70 ... 79:
            return "아~주 똑같아요😁"
        case 60 ... 69:
            return ""
        case 50 ... 59:
            return "웃음은 안 따라할끼니?"
        case 40 ... 49:
            return ""
        case 30 ... 39:
            return "다음 웃음은 100점 가보즈아~!"
        case 20 ... 29:
            return "모르게쒀요~"
        case 10 ... 19:
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
            "체리": "cherry",
        ]

        if let rawValue = learnerMapping[targetLearnerName] {
            return "\(rawValue)_dance"
        }

        return "dance_1"
    }

    func retry() {
        appCoordinator?.pop()
    }

    func setIsShowingNicknameInput(_ isShowingNicknameInput: Bool) {
        self.isShowingNicknameInput = isShowingNicknameInput
    }

    func setNickname(_ nickname: String) {
        self.nickname = nickname
    }

    func analyzeRecord() {
        isLoading = true

        defer {
            self.isLoading = false
        }

        // TODO: 녹음 비교 분석 로직
        try? analyzer.analyzeLaugh(url: Bundle.main.url(forResource: resultViewData.targetLearner.laughAudioURL, withExtension: nil) ?? URL(fileURLWithPath: ""))
        try? analyzer.analyzeLaugh(data: resultViewData.audioData)

        let dtw = DTW()

        // --- 1. MFCC 데이터로 음색 유사도 계산 ---

        // 두 MFCC 벡터 간의 '유클리드 제곱 거리'를 계산하는 함수를 정의합니다.
        // vDSP 라이브러리를 사용하면 효율적으로 연산할 수 있습니다.
        let cosineDistance: ([Float], [Float]) -> Float = { a, b in
            guard a.count == b.count, !a.isEmpty else { return 2.0 } // 2.0은 최대 거리

            var dotProduct: Float = 0
            var normA: Float = 0
            var normB: Float = 0

            // vDSP를 사용하여 내적(dot product)과 각 벡터의 크기(norm)를 효율적으로 계산합니다.
            vDSP_dotpr(a, 1, b, 1, &dotProduct, vDSP_Length(a.count))
            vDSP_svesq(a, 1, &normA, vDSP_Length(a.count))
            vDSP_svesq(b, 1, &normB, vDSP_Length(b.count))

            normA = sqrt(normA)
            normB = sqrt(normB)

            // 분모가 0이 되는 것을 방지합니다.
            guard normA > 0, normB > 0 else { return 2.0 }

            // 코사인 유사도를 계산합니다: (A · B) / (||A|| * ||B||)
            let similarity = dotProduct / (normA * normB)

            // 코사인 거리를 반환합니다: 1 - 유사도. (거리는 0~2 사이의 값을 가집니다)
            return 1 - similarity
        }

        // 제네릭으로 개선된 dtwSimilarity 함수를 호출합니다.
        // x, y에는 MFCC 데이터([[Float]])를, dist에는 위에서 정의한 유클리드 거리 함수를 전달합니다.
        let mfccResult = dtw.dtwSimilarity(
            x: analyzer.targetResult.mfccData,
            y: analyzer.userResult.mfccData,
            dist: cosineDistance
        ) + 5
        //                print("-----------")
        //                print(analyzer.targetResult.mfccData)
        //                print(analyzer.userResult.mfccData)
        //                print("-----------")

        // 1. targetResult와 userResult의 pitchData에서 0이 아닌 값만 필터링합니다.
        let filteredTargetPitch = analyzer.targetResult.pitchData.filter { $0 > 0 }
        let filteredUserPitch = analyzer.userResult.pitchData.filter { $0 > 0 }

        // Z-점수 정규화 함수
        func zScoreNormalize(_ data: [Float]) -> [Float] {
            guard !data.isEmpty else { return [] }
            let mean = data.reduce(0, +) / Float(data.count)
            let stdDev = sqrt(data.map { pow($0 - mean, 2) }.reduce(0, +) / Float(data.count))
            guard stdDev > 0 else { return data.map { _ in 0 } } // 모든 값이 같을 경우 0으로 반환
            return data.map { ($0 - mean) / stdDev }
        }

        // 2. 필터링된 데이터에 Z-점수 정규화를 적용합니다.
        let normalizedTargetPitch = zScoreNormalize(filteredTargetPitch)
        let normalizedUserPitch = zScoreNormalize(filteredUserPitch)

        let pitchResult: Float
        if !normalizedTargetPitch.isEmpty && !normalizedUserPitch.isEmpty {
            pitchResult = dtw.dtwSimilarity(
                x: normalizedTargetPitch,
                y: normalizedUserPitch,
                targetLength: 200
            )
        } else {
            pitchResult = 0.0
        }

        let speedResult = (1 - abs(analyzer.targetResult.laughSpeed - analyzer.userResult.laughSpeed) / analyzer.targetResult.laughSpeed) * 100

        print("MFCC DTW Result: \(String(format: "%.2f", mfccResult))점")
        print("Pitch DTW Result: \(String(format: "%.2f", pitchResult))점")
        print("Speed Distance Result: \(speedResult) 점")

        let finalScore = mfccResult * 0.4 + pitchResult * 0.4 + speedResult * 0.2

        score = Int(finalScore.rounded())
    }

    func uploadScore(_ context: ModelContext) {
        let repository = ShadowingRecordRepository(context: context)

        do {
            try repository.saveScore(
                userName: nickname,
                targetLearner: resultViewData.targetLearner,
                finalScore: score
            )
        } catch {
            print("점수 저장 실패: \(error)")
        }

        let scoreBoardViewData = ScoreBoardViewData(targetLearner: resultViewData.targetLearner)

        appCoordinator?.push(.scoreBoard(scoreBoardViewData))
    }
}
