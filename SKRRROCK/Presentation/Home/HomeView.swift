//
//  HomeView.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
  @Environment(\.modelContext) private var context
  @Query private var targetLearners: [TargetLearner]

  @State private var viewModel: HomeViewModel

  init(viewModel: HomeViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      ColorTokens.slate800
        .ignoresSafeArea()

      VStack(spacing: 80) {
        VStack {
          Text("오늘 한번 웃어볼ROCK?")
            .font(FontTokens.headingMdMedium)
            .foregroundStyle(ColorTokens.white)
          
          Text("듣고 따라 웃어보자! 푸하하하하항 SKRRR~")
            .font(FontTokens.bodyLgRegular)
            .foregroundStyle(ColorTokens.white)
        }

        LazyVGrid(
          columns: Array(repeating: GridItem(spacing: 20), count: 2),
          spacing: 20
        ) {
          ForEach(targetLearners) { learner in
            Button {
              viewModel.navigationToPersonalPage(learner)
            } label: {
              HomePersonGridItem(name: learner.name, image: learner.emoji)
            }
          }
        }
      }
      .padding()
    }
  }
}

#Preview {
  let viewModel = DefaultHomeViewModel()

  HomeView(viewModel: viewModel)
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
