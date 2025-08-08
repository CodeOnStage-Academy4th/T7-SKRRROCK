//
//  SKRRROCKApp.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftData
import SwiftUI

@main
struct SKRRROCKApp: App {
  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
}

struct MainView: View {
  @State private var appCoordinator: AppCoordinator
  
  init() {
    self.appCoordinator = AppCoordinator()
  }
  
  var body: some View {
    NavigationStack(path: $appCoordinator.navigationPath) {
      appCoordinator.view(.home)
        .navigationDestination(for: Route.self) { route in
          appCoordinator.view(route)
        }
    }
    .modelContainer(for: [TargetLearner.self, ShadowingRecord.self]) {
      result in
      switch result {
      case .success(let container):
        TargetLearnerRepository.setupDefaultLearners(
          context: container.mainContext
        )
      case .failure(let error):
        print("ModelContainer 생성 실패: \(error)")
      }
    }
  }
}

#Preview {
  MainView()
}
