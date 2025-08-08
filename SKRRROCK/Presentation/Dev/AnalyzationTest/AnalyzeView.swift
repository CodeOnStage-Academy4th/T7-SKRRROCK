//
//  AnalyzeView.swift
//  SKRRROCK
//
//  Created by 김현기 on 8/9/25.
//

import Accelerate
import SwiftUI

struct AnalyzeView: View {
    let audioData: Data

    @State private var analyzer = LaughAnalyzerDev()

    var body: some View {
        ScrollView {
            HStack {
                Text("Target Laugh Data")
                    .font(.title)
                    .padding()

                Spacer()

                Button("Analyze") {
                    try? analyzer.analyzeLaugh(url: Bundle.main.url(forResource: "cherry_laugh", withExtension: "m4a") ?? URL(fileURLWithPath: ""))
                }
            }

            Text("Target Laugh Data: \(analyzer.targetResult.laughSpeed, specifier: "%.2f") Hz")
                .font(.headline)
                .padding()

            GraphView(data: analyzer.targetResult.volumeData, label: "Volume (RMS)")
            GraphView(data: analyzer.targetResult.pitchData, label: "Pitch (Hz)")

            Divider().padding()

            HStack {
                Text("User Laugh Data")
                    .font(.title)
                    .padding()

                Spacer()

                Button("Analyze") {
                    try? analyzer.analyzeLaugh(data: audioData)
                }
            }

            Text("User Laugh Data: \(analyzer.userResult.laughSpeed, specifier: "%.2f") Hz")
                .font(.headline)
                .padding()

            GraphView(data: analyzer.userResult.volumeData, label: "Volume (RMS)")
            GraphView(data: analyzer.userResult.pitchData, label: "Pitch (Hz)")

            Divider().padding()

            Button("Compare") {
                let dtw = DTW()

                // --- 1. MFCC 데이터로 음색(Timbre) 유사도 계산 ---

                // 두 MFCC 벡터 간의 '유클리드 제곱 거리'를 계산하는 함수를 정의한다.
                // vDSP 라이브러리를 사용해 효율적으로 연산한다.
                let euclideanDistanceSquared: ([Float], [Float]) -> Float = { a, b in
                    guard a.count == b.count else { return Float.infinity }
                    var sum: Float = 0
                    vDSP_distancesq(a, 1, b, 1, &sum, vDSP_Length(a.count))
                    return sum
                }

                // 제네릭으로 개선된 dtwSimilarity 함수를 호출한다.
                // x, y에는 MFCC 데이터([[Float]])를, dist에는 위에서 정의한 유클리드 거리 함수를 전달한다.
                let mfccResult = dtw.dtwSimilarity(
                    x: analyzer.targetResult.mfccData,
                    y: analyzer.userResult.mfccData,
                    dist: euclideanDistanceSquared,
                    targetLength: 100 // MFCC는 프레임 수가 적으므로 targetLength를 적절히 조절한다.
                )

                // 1. targetResult와 userResult의 pitchData에서 0이 아닌 값만 필터링합니다.
                let filteredTargetPitch = analyzer.targetResult.pitchData.filter { $0 > 0 }
                let filteredUserPitch = analyzer.userResult.pitchData.filter { $0 > 0 }

                // Z-점수 정규화 함수
                func zScoreNormalize(_ data: [Float]) -> [Float] {
                    guard !data.isEmpty else { return [] }
                    let mean = data.reduce(0, +) / Float(data.count)
                    let stdDev = sqrt(data.map { pow($0 - mean, 2) }.reduce(0, +) / Float(data.count))
                    guard stdDev > 0 else { return data.map { _ in 0 } } // 모든 값이 같을 경우 0으로 반환
                    return data.map { ($0 - mean) / stdDev }
                }

                // 2. 필터링된 데이터에 Z-점수 정규화를 적용합니다.
                let normalizedTargetPitch = zScoreNormalize(filteredTargetPitch)
                let normalizedUserPitch = zScoreNormalize(filteredUserPitch)

                let pitchResult: Float
                if !normalizedTargetPitch.isEmpty && !normalizedUserPitch.isEmpty {
                    pitchResult = dtw.dtwSimilarity(
                        x: normalizedTargetPitch,
                        y: normalizedUserPitch,
                        targetLength: 100
                    )
                } else {
                    pitchResult = 0.0
                }

                let speedResult = (1 - abs(analyzer.targetResult.laughSpeed - analyzer.userResult.laughSpeed) / analyzer.targetResult.laughSpeed) * 100

                print("MFCC DTW Result: \(String(format: "%.2f", mfccResult))점")
                print("Pitch DTW Result: \(String(format: "%.2f", pitchResult))점")
                print("Speed Distance Result: \(speedResult) 점")
            }
        }
    }
}

#Preview {
    AnalyzeView(audioData: Data())
}
