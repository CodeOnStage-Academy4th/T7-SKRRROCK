//
//  PersonalPageView.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct PersonalPageView: View {
  @State private var viewModel: PersonalPageViewModel

  init(viewModel: PersonalPageViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      ColorTokens.slate800
        .ignoresSafeArea()

      VStack(spacing: 20) {
        HomePersonGridItem(
          name: viewModel.targetLearner.name,
          image: viewModel.targetLearner.emoji
        )
        .frame(maxWidth: 171)

        if viewModel.isPlaying {
          LargeButton(title: "재생중...", systemImage: "waveform") {}
            .disabled(true)
        } else {
          LargeButton(title: "웃음 듣기", systemImage: "play") {
            viewModel.playAudio()
          }
        }

        VStack(spacing: 24) {
          Text("RANKING")

          if viewModel.sortedRecords.isEmpty {
            Text("처음 기록을 세워보세요.")
              .opacity(0.5)
            Spacer()
          } else {
            ForEach(
              Array(
                zip(viewModel.sortedRecords.indices, viewModel.sortedRecords)
              ),
              id: \.0
            ) { index, record in
              let rank = index + 1
              HStack {
                Group {
                  switch rank {
                  case 1:
                    Image("GoldMedal")
                  case 2:
                    Image("SilverMedal")
                  case 3:
                    Image("BronzeMedal")
                  default:
                    Text("\(rank)th")
                  }
                }
                .frame(maxWidth: 40)
                Text(record.userName)
                Spacer()
                Text("\(record.finalScore)점")
              }
              .frame(maxHeight: 30)
              .if(rank == 1) { view in
                view.foregroundStyle(ColorTokens.yellow500)
              }
            }
          }
        }
        .font(FontTokens.headingSmMedium)
        .foregroundStyle(ColorTokens.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, maxHeight: 320)
        .gradientBackground()

        LargeButton(title: "따라하기", systemImage: "mic", colored: true) {
          viewModel.navigateToRecording()
        }
      }
      .padding(.horizontal, 40)
    }
  }
}

#Preview {
  let gwangro = DefaultTargetLearner.gwangro
  let targetLearner = TargetLearner(
    name: gwangro.name,
    emoji: gwangro.emoji,
    laughAudioURL: gwangro.audioFileName
  )
  targetLearner.shadowingRecords = [
    .init(userName: "Test1", finalScore: 59, targetLearner: targetLearner),
    .init(userName: "Test2", finalScore: 44, targetLearner: targetLearner),
    .init(userName: "Test3", finalScore: 91, targetLearner: targetLearner),
    .init(userName: "Test4", finalScore: 92, targetLearner: targetLearner),
    .init(userName: "Test5", finalScore: 95, targetLearner: targetLearner),
    .init(userName: "Test6", finalScore: 99, targetLearner: targetLearner),
  ]

  let viewModel: PersonalPageViewModel = DefaultPersonalPageViewModel(
    targetLearner: targetLearner
  )

  return PersonalPageView(viewModel: viewModel)
}
