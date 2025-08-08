//
//  HomeView.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

struct HomeView: View {
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
          HomePersonGridItem(name: "광로", image: "Gwangro")
          HomePersonGridItem(name: "체리", image: "Cherry")
          HomePersonGridItem(name: "에디", image: "Eddey")
          HomePersonGridItem(name: "세나", image: "Sena")
        }
      }
      .padding()
    }
  }
}

#Preview {
  let viewModel = DefaultHomeViewModel()

  HomeView(viewModel: viewModel)
}
