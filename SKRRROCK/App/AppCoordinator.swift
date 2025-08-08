//
//  AppCoordinator.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

enum Route: Hashable {
  case home
  case personalPage(TargetLearner)
  case recording(TargetLearner)
  case result(ResultViewData)
  case scoreBoard(ScoreBoardViewData)
}

@Observable
final class AppCoordinator {
  var navigationPath: NavigationPath
  
  init() {
    self.navigationPath = NavigationPath()
  }
  
  func push(_ route: Route) {
    navigationPath.append(route)
  }
  
  func pop() {
    navigationPath.removeLast()
  }
  
  func popToRoot() {
    navigationPath = NavigationPath()
  }
  
  @ViewBuilder
  func view(_ route: Route) -> some View {
    switch route {
    case .home:
      let viewModel: HomeViewModel = DefaultHomeViewModel(appCoordinator: self)
      HomeView(viewModel: viewModel)
    case .personalPage(let targetLearner):
      let viewModel: PersonalPageViewModel = DefaultPersonalPageViewModel(targetLearner: targetLearner, appCoordinator: self)
      PersonalPageView(viewModel: viewModel)
    case .recording(let targetLearner):
      let viewModel: RecordingViewModel = DefaultRecordingViewModel(targetLearner: targetLearner, appCoordinator: self)
      RecordingView(viewModel: viewModel)
    case .result(let resultViewData):
      let viewModel: ResultViewModel = DefaultResultViewModel(resultViewData: resultViewData, appCoordinator: self)
      ResultView(viewModel: viewModel)
    case .scoreBoard(let scoreBoardViewData):
      let viewModel: ScoreBoardViewModel = DefaultScoreBoardViewModel(scoreBoardViewData: scoreBoardViewData, appCoordinator: self)
      ScoreBoardView(viewModel: viewModel)
    }
  }
}
