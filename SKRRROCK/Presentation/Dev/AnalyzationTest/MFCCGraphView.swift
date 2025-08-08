//
//  MFCCGraphView.swift
//  SKRRROCK
//
//  Created by 김현기 on 8/9/25.
//

// MFCCGraphView.swift

import SwiftUI

struct MFCCGraphView: View {
    var data: [[Float]]
    var label: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .padding(.bottom, 2)

            // Canvas를 사용하여 2D 그래픽을 직접 그린다.
            Canvas { context, size in
                // 데이터가 비어있으면 아무것도 그리지 않는다.
                guard let firstFrame = data.first, !firstFrame.isEmpty else { return }

                let timeFrameCount = data.count
                let mfccCoefficientCount = firstFrame.count

                // 각 셀(사각형)의 너비와 높이를 계산한다.
                let rectWidth = size.width / CGFloat(timeFrameCount)
                let rectHeight = size.height / CGFloat(mfccCoefficientCount)

                // 전체 데이터에서 최소값과 최대값을 찾아 색상 정규화에 사용한다.
                let allValues = data.flatMap { $0 }
                let maxVal = allValues.max() ?? 1
                let minVal = allValues.min() ?? -1
                let range = maxVal - minVal == 0 ? 1 : maxVal - minVal

                // 중첩 루프를 돌며 각 MFCC 계수 값을 사각형으로 그린다.
                for (timeIndex, frame) in data.enumerated() {
                    for (coeffIndex, value) in frame.enumerated() {
                        // 현재 값의 위치(x, y)를 계산한다.
                        let x = CGFloat(timeIndex) * rectWidth
                        // y축은 아래로 갈수록 값이 커지므로, 계수 인덱스를 반전시켜준다.
                        let y = size.height - (CGFloat(coeffIndex + 1) * rectHeight)

                        // 값의 크기에 따라 색상을 결정한다. (최소: 파랑, 중간: 초록, 최대: 빨강)
                        let normalizedValue = (value - minVal) / range
                        let hue = (1.0 - CGFloat(normalizedValue)) * 0.7 // 0.7(파랑) ~ 0.0(빨강)
                        let color = Color(hue: hue, saturation: 1.0, brightness: 1.0)

                        // 계산된 위치에 색칠된 사각형을 그린다.
                        let rect = CGRect(x: x, y: y, width: rectWidth, height: rectHeight)
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }
            .frame(height: 130) // MFCC 계수 개수(13)에 맞춰 적절한 높이 설정
            .background(Color.black)
            .cornerRadius(5)
        }
        .padding(.horizontal)
    }
}
