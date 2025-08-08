//
//  GradientLoading.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct GradientLoading: View {
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
        let angle: Double = timeline.date.timeIntervalSince1970
          .truncatingRemainder(dividingBy: 360) * 2

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
              .trim(from: 0, to: 0.2)
              .fill(.clear)
              .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
              .padding(padding)
              .rotationEffect(Angle(radians: angle))
          }
        }
      }
    }
    .frame(maxWidth: size, maxHeight: size)
  }
}

#Preview {
  GradientLoading()
}
