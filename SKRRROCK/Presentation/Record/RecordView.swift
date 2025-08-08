//
//  RecordView.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

struct RecordView: View {
  @State private var viewModel: RecordViewModel

  init(viewModel: RecordViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    EmptyView()
  }
}

#Preview {
  let viewModel = DefaultRecordViewModel(audioRecorder: MockAudioRecorder())

  RecordView(viewModel: viewModel)
}
