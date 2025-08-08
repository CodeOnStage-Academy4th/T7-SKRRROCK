//
//  ResultViewModel.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftData
import SwiftUI

struct ResultViewData: Hashable {
  let targetLearner: TargetLearner
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

  init(resultViewData: ResultViewData, appCoordinator: AppCoordinator? = nil) {
    self.isLoading = false
    self.score = 0
    self.targetLearnerName = resultViewData.targetLearner.name
    self.isShowingNicknameInput = false
    self.nickname = ""

    self.resultViewData = resultViewData

    self.appCoordinator = appCoordinator
  }

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
    self.isLoading = true

    defer {
      self.isLoading = false
    }

    // TODO: 녹음 비교 분석 로직
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
