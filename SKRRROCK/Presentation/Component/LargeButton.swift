//
//  LargeButton.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct LargeButton: View {
  let title: String
  let systemImage: String
  var colored: Bool = false
  let action: () -> Void

  @Environment(\.isEnabled) private var isEnabled

  var body: some View {
    Button {
      action()
    } label: {
      Label(title, systemImage: systemImage)
        .font(FontTokens.bodyLgRegular)
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background {
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
              LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
              )
              .opacity(isEnabled ? 1.0 : 0.6)
            )
            .if(!colored) { view in
              view
                .strokeBorder(
                  LinearGradient(
                    colors: [ColorTokens.white, ColorTokens.transparent],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                )
            }
        }
    }
  }

  private var foregroundColor: Color {
    if colored {
      return ColorTokens.white
    } else {
      return ColorTokens.black
    }
  }

  private var colors: [Color] {
    if colored {
      return [
        ColorTokens.blue600.opacity(0.9),
        ColorTokens.blue800.opacity(0.6),
      ]
    } else {
      return [
        ColorTokens.white.opacity(0.9),
        ColorTokens.white.opacity(0.6),
      ]
    }
  }
}

#Preview {
  ZStack {
    ColorTokens.slate800
      .ignoresSafeArea()

    VStack {
      LargeButton(title: "웃음 듣기", systemImage: "play") {}
      LargeButton(title: "재생중...", systemImage: "waveform") {}
        .disabled(true)
      LargeButton(title: "웃음 듣기", systemImage: "play", colored: true) {}
    }
  }
}
