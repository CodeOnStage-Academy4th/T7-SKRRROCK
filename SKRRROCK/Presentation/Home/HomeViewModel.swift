//
//  HomeViewModel.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

protocol HomeViewModel {
  func navigationToPersonalPage(_ targetLearner: TargetLearner)
}

@Observable
class DefaultHomeViewModel: HomeViewModel {
  private let appCoordinator: AppCoordinator?
  
  init(appCoordinator: AppCoordinator? = nil) {
    self.appCoordinator = appCoordinator
  }
  
  func navigationToPersonalPage(_ targetLearner: TargetLearner) {
    appCoordinator?.push(.personalPage(targetLearner))
  }
}
