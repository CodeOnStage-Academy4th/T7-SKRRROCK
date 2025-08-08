//
//  HomePersonGridItem.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct HomePersonGridItem: View {
  let name: String
  let image: String

  var body: some View {
    VStack(spacing: 0) {
      Text(name)
        .font(FontTokens.headingSmMedium)
        .foregroundStyle(ColorTokens.white)
        .padding(.top)
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 137, maxHeight: 149)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: 200)
    .gradientBackground()
  }
}

#Preview {
  ZStack {
    ColorTokens.slate800
      .ignoresSafeArea()

    HomePersonGridItem(
      name: "광로",
      image: "Gwangro"
    )
  }
}
