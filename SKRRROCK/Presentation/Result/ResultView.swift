//
//  ResultView.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftUI

struct ResultView: View {
  @State private var viewModel: ResultViewModel

  init(viewModel: ResultViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    EmptyView()
  }
}
