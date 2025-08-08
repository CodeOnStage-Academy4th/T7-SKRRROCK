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
    EmptyView()
  }
}

#Preview {
  let viewModel = DefaultHomeViewModel()

  HomeView(viewModel: viewModel)
}
