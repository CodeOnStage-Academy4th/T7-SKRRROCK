//
//  ScoreBoardViewModel.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct ScoreBoardViewData: Hashable {
  let targetLearner: TargetLearner
}

protocol ScoreBoardViewModel {
  var sortedRecords: [ShadowingRecord] { get }
  
  func navigateToHome()
}

@Observable
final class DefaultScoreBoardViewModel: ScoreBoardViewModel {
  var sortedRecords: [ShadowingRecord] {
    Array(scoreBoardViewData.targetLearner.shadowingRecords.sorted { $0.finalScore > $1.finalScore }.prefix(5))
  }
  
  private let scoreBoardViewData: ScoreBoardViewData
  
  private let appCoordinator: AppCoordinator?
  
  init(scoreBoardViewData: ScoreBoardViewData, appCoordinator: AppCoordinator? = nil) {
    self.scoreBoardViewData = scoreBoardViewData
    
    self.appCoordinator = appCoordinator
  }
  
  func navigateToHome() {
    appCoordinator?.popToRoot()
  }
}
