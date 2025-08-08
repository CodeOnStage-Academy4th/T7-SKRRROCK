//
//  GradientBackgroundStyle.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct GradientBackground: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background {
        RoundedRectangle(cornerRadius: 30)
          .inset(by: 2)
          .fill(
            LinearGradient(
              colors: [ColorTokens.white, ColorTokens.transparent],
              startPoint: .top,
              endPoint: .bottom
            )
            .opacity(0.5)
          )
        RoundedRectangle(cornerRadius: 30)
          .stroke(
            LinearGradient(
              colors: [
                ColorTokens.white, ColorTokens.transparent,
                ColorTokens.white.opacity(0.77),
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
            .blendMode(.overlay),
            lineWidth: 2
          )
      }
  }
}

#Preview {
  Text("Hello, world!")
    .modifier(GradientBackground())
}

extension View {
  func gradientBackground() -> some View {
    self
      .modifier(GradientBackground())
  }
}
