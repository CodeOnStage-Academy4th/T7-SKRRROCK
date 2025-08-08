//
//  DTW.swift
//  test2
//
//  Created by 이서현 on 8/9/25.
//
// DTW.swift

import Foundation

struct DTW {
    /// 다양한 타입의 배열 길이를 선형 보간(Linear Interpolation)을 통해 조절하는 제네릭 함수이다.
    /// - Parameters:
    ///   - input: 리사이징할 원본 배열
    ///   - targetLength: 목표로 하는 배열의 길이
    ///   - interpolate: 두 요소 사이를 보간하는 방법을 정의한 클로저
    /// - Returns: 목표 길이로 리사이징된 새로운 배열
    func resizeArray<T>(_ input: [T], targetLength: Int, interpolate: (T, T, Float) -> T) -> [T] {
        guard input.count >= 2, targetLength > 1 else { return input }

        var result = [T]()
        let n = input.count
        let scale = Float(n - 1) / Float(targetLength - 1)

        for i in 0 ..< targetLength {
            let pos = Float(i) * scale
            let leftIndex = Int(floor(pos))
            let rightIndex = min(leftIndex + 1, n - 1)
            let fraction = pos - Float(leftIndex)

            let leftValue = input[leftIndex]
            let rightValue = input[rightIndex]

            // 제공된 보간 클로저를 사용하여 값을 계산한다.
            let interpolated = interpolate(leftValue, rightValue, fraction)
            result.append(interpolated)
        }
        return result
    }

    /// 두 시퀀스(T 타입 배열) 간의 DTW 거리를 계산하고, 이를 0점에서 100점 사이의 유사도 점수로 변환하는 제네릭 함수이다.
    /// - Parameters:
    ///   - x: 첫 번째 시퀀스
    ///   - y: 두 번째 시퀀스
    ///   - dist: 두 요소(T 타입) 사이의 거리를 계산하는 함수
    ///   - targetLength: DTW 계산 전 시퀀스를 리사이징할 목표 길이
    /// - Returns: 0과 100 사이의 유사도 점수
    func dtwSimilarity<T>(x: [T], y: [T], dist: (T, T) -> Float, targetLength: Int = 100, sensitivity: Float = 1.0) -> Float {
        guard !x.isEmpty, !y.isEmpty else { return 0 }

        // 데이터 타입에 따른 선형 보간 로직을 정의한다.
        let interpolator: (T, T, Float) -> T = { a, b, fraction in
            // T가 Float일 경우
            if let valA = a as? Float, let valB = b as? Float {
                return (valA + fraction * (valB - valA)) as! T
            }
            // T가 [Float] (벡터)일 경우
            if let vecA = a as? [Float], let vecB = b as? [Float], vecA.count == vecB.count {
                var resultVec = [Float](repeating: 0, count: vecA.count)
                for i in 0 ..< vecA.count {
                    resultVec[i] = vecA[i] + fraction * (vecB[i] - vecA[i])
                }
                return resultVec as! T
            }
            // 보간이 불가능한 타입일 경우, 왼쪽 값을 그대로 반환한다.
            return a
        }

        let xResized = resizeArray(x, targetLength: targetLength, interpolate: interpolator)
        let yResized = resizeArray(y, targetLength: targetLength, interpolate: interpolator)

        let m = xResized.count
        let n = yResized.count
        var dtw = Array(repeating: Array(repeating: Float.infinity, count: n + 1), count: m + 1)
        dtw[0][0] = 0

        for i in 1 ... m {
            for j in 1 ... n {
                // 외부에서 전달받은 거리 함수(dist)를 사용하여 비용을 계산한다.
                let cost = dist(xResized[i - 1], yResized[j - 1])
                let minPrev = min(dtw[i - 1][j], dtw[i][j - 1], dtw[i - 1][j - 1])
                dtw[i][j] = cost + minPrev
            }
        }

//        // 경로 길이를 고려하여 거리를 정규화한다.
//        let distance = dtw[m][n] / Float(m + n)
//
//        // 정규화된 거리를 기반으로 유사도 점수를 계산한다 (0에 가까울수록 100점).
//        // 거리가 1을 초과하는 경우 0점으로 처리하여 안정성을 높인다.
//        let similarityPercent = max(0, 1 - distance) * 100
//
//        return similarityPercent

        // 경로 길이를 고려하여 거리를 정규화한다.
        let distance = dtw[m][n] / Float(m + n)

        // --- ⬇️ 수정된 부분 ⬇️ ---
        // 유사도 변환 공식을 '1 / (1 + distance)' 형태로 변경하여
        // 0 이상의 모든 거리 값을 0~100점 사이로 안정적으로 변환한다.
        let similarityPercent = 100 * exp(-sensitivity * distance)
        // --- 수정 완료 ---

        return similarityPercent
    }

    /// `[Float]` 타입 배열을 위한 편의 함수입니다.
    func dtwSimilarity(x: [Float], y: [Float], targetLength: Int = 100, sensitivity: Float = 1.0) -> Float {
        let floatDistance = { (a: Float, b: Float) -> Float in abs(a - b) }
        return dtwSimilarity(x: x, y: y, dist: floatDistance, targetLength: targetLength, sensitivity: sensitivity)
    }
}
