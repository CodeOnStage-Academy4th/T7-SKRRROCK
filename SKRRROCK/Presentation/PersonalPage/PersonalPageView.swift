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
        HomePersonGridItem(name: "광로", image: "Gwangro")
          .frame(maxWidth: 171)

        LargeButton(title: "웃음 듣기", systemImage: "play") {

        }

        VStack(spacing: 24) {
          Text("RANKING")

          ScrollView {
            LazyVStack(spacing: 24) {
              ForEach(1..<6) { rank in
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
                  Text("프라이데이")
                  Spacer()
                  Text("99점")
                }
                .frame(maxHeight: 30)
                .if(rank == 1) { view in
                  view.foregroundStyle(ColorTokens.yellow500)
                }
              }
            }
          }
          .frame(maxHeight: 232)
        }
        .font(FontTokens.headingSmMedium)
        .foregroundStyle(ColorTokens.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .gradientBackground()

        LargeButton(title: "따라하기", systemImage: "mic", colored: true) {

        }
      }
      .padding(.horizontal, 40)
    }
  }
}

#Preview {
  let viewModel: PersonalPageViewModel = DefaultPersonalPageViewModel()

  PersonalPageView(viewModel: viewModel)
}
