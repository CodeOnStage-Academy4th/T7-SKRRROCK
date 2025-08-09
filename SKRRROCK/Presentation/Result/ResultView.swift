//
//  ResultView.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftUI

struct ResultView: View {
  @Environment(\.modelContext) private var context
  
  @State private var viewModel: ResultViewModel

  init(viewModel: ResultViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      ColorTokens.slate800
        .ignoresSafeArea()

      VStack {
        if viewModel.isLoading {
          Text("분석중...")
            .font(FontTokens.headingMdMedium)
            .foregroundColor(.white)
          
          GradientLoading(size: 200, color: ColorTokens.slate800)
        } else {
            ZStack {
                Image("scoreBackground")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 90)
                
                VStack {
                    Text("SCORE")
                        .font(FontTokens.bodyLgMedium)
                        .foregroundColor(.white)
                    
                    ZStack {
                        ForEach(0..<24, id: \.self) { i in
                            let theta = 2 * .pi * CGFloat(i) / CGFloat(24)
                            Text("\(viewModel.score)")
                                .font(Font.custom(FontTokens.goormSansBold, size: 80))
                                .foregroundColor(.white)
                                .offset(x: cos(theta) * 6, y: sin(theta) * 6)
                        }
                        
                        Text("\(viewModel.score)")
                            .font(Font.custom(FontTokens.goormSansBold, size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(hex: "0900FF"), location: 0.0),
                                        .init(color: Color(hex: "FF00FB"), location: 0.5),
                                        .init(color: Color(hex: "00A6FF"), location: 1.0),
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                }
            }
          
          // MARK: 점수대 별 멘트
          VStack(spacing: 4) {
            Text(viewModel.getFirstMessage())
              .font(FontTokens.headingLgMedium)
            Text(viewModel.getSecondMessage())
              .font(FontTokens.headingSmRegular)
          }
          .foregroundColor(.white)
          
          Image(viewModel.getDanceImageName())
            .resizable()
            .scaledToFit()
            .frame(width: 256)
          
          HStack {
            LargeButton(title: "다시하기", systemImage: "arrow.counterclockwise") {
              viewModel.retry()
            }
            
            LargeButton(title: "랭킹 등록", systemImage: "bookmark", colored: true) {
              viewModel.setIsShowingNicknameInput(true)
            }
            .alert(
              "닉네임을 적어주세요.",
              isPresented: Binding(
                get: {
                  viewModel.isShowingNicknameInput
                },
                set: {
                  viewModel.setIsShowingNicknameInput($0)
                }
              )
            ) {
              TextField(
                "닉네임",
                text: Binding(
                  get: {
                    viewModel.nickname
                  },
                  set: {
                    viewModel.setNickname($0)
                  }
                )
              )
              Button("취소", role: .cancel) {
                viewModel.setIsShowingNicknameInput(false)
              }
              Button("등록") {
                viewModel.uploadScore(context)
              }
              .disabled(viewModel.nickname.isEmpty)
            }
          }
        }
      }
      .padding()
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      viewModel.analyzeRecord()
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

  let viewModel = DefaultResultViewModel(
    resultViewData: ResultViewData(targetLearner: targetLearner, audioData: Data())
  )

  return ResultView(viewModel: viewModel)
}
