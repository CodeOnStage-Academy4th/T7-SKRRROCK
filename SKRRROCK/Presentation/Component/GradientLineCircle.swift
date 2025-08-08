//
//  GradientLineCircle.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct GradientLineCircle: View {
  var size: CGFloat = 200
  var color: Color = Color.white

  private var radius: CGFloat {
    size * 0.05
  }

  private var padding: CGFloat {
    size * 0.05
  }

  var body: some View {
    ZStack {
      TimelineView(.animation(minimumInterval: 0.01)) { timeline in
        let angle: CGFloat = timeline.date.timeIntervalSince1970
          .truncatingRemainder(dividingBy: 360)

        AngularGradient(
          colors: [
            ColorTokens.blue700,
            Color(hex: "#00FF8C"),
            Color(hex: "#B300FF"),
            ColorTokens.blue700,
          ],
          center: .center
        )
        .mask {
          ZStack {
            Circle()
              .fill(.black)
              .padding(padding)
              .offset(x: radius * cos(angle), y: radius * sin(angle))

            Circle()
              .fill(.black)
              .padding(padding)
              .offset(x: radius * cos(angle * 2), y: radius * sin(angle * 2))
          }
        }
      }
      Circle()
        .fill(color)
        .padding(padding)
    }
    .blur(radius: 12)
    .frame(maxWidth: size, maxHeight: size)
  }
}

#Preview {
  GradientLineCircle()
}
