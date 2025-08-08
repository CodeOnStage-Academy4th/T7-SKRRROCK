//
//  LaughAnalyzerDev+MFCC.swift
//  SKRRROCK
//
//  Created by 김현기 on 8/9/25.
//

import Accelerate
import AVFoundation
import SwiftUI

//extension LaughAnalyzerDev {
//    // MARK: - MFCC 계산 관련 함수들
//
//    // --- 완성된 MFCC 계산 관련 함수들 ---
//
//    func calculateMFCC(buffer: AVAudioPCMBuffer, nMFCC: Int, nFFT: Int, melFilterBank: [[Float]], dctSetup: vDSP.DCT) -> [Float] {
//        guard let channelData = buffer.floatChannelData?[0] else { return [] }
//        var samples = [Float](UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
//
//        // 1. 프레이밍 및 윈도잉
//        if samples.count < nFFT {
//            samples += [Float](repeating: 0, count: nFFT - samples.count)
//        }
//        var window = [Float](repeating: 0, count: nFFT)
//        vDSP_hamm_window(&window, vDSP_Length(nFFT), 0)
//        vDSP_vmul(samples, 1, window, 1, &samples, 1, vDSP_Length(nFFT))
//
//        // 2. FFT (고속 푸리에 변환)
//        let log2n = vDSP_Length(log2(Float(nFFT)))
//        guard let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2)) else { return [] }
//        defer { vDSP_destroy_fftsetup(fftSetup) }
//
//        var realp = [Float](repeating: 0, count: nFFT / 2)
//        var imagp = [Float](repeating: 0, count: nFFT / 2)
//
//        // --- 최종 반환 값을 저장할 변수 ---
//        var finalMfccs = [Float](repeating: 0, count: nMFCC)
//
//        realp.withUnsafeMutableBufferPointer { realpBuffer in
//            imagp.withUnsafeMutableBufferPointer { imagpBuffer in
//                var splitComplex = DSPSplitComplex(realp: realpBuffer.baseAddress!, imagp: imagpBuffer.baseAddress!)
//
//                samples.withUnsafeBufferPointer { samplesBuffer in
//                    let unsafePtr = UnsafeRawPointer(samplesBuffer.baseAddress!).bindMemory(to: DSPComplex.self, capacity: nFFT)
//                    vDSP_ctoz(unsafePtr, 2, &splitComplex, 1, vDSP_Length(nFFT / 2))
//                }
//
//                vDSP_fft_zrip(fftSetup, &splitComplex, 1, log2n, Int32(FFT_FORWARD))
//
//                // 3. 파워 스펙트럼
//                var magnitudes = [Float](repeating: 0, count: nFFT / 2)
//                vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(nFFT / 2))
//
//                // 4. 멜 필터뱅크 적용
//                let flattenedFilters = melFilterBank.flatMap { $0 }
//                var melEnergies = [Float](repeating: 0, count: melFilterBank.count)
//                vDSP_mmul(magnitudes, 1, flattenedFilters, 1, &melEnergies, 1, 1, vDSP_Length(melFilterBank.count), vDSP_Length(nFFT / 2))
//
//                // 5. 로그 에너지
//                var logMelEnergies = [Float](repeating: 0, count: melFilterBank.count)
//                var initialPower: Float = 1.0
//                vDSP_vdbcon(melEnergies, 1, &initialPower, &logMelEnergies, 1, vDSP_Length(melFilterBank.count), 1)
//
//                // 6. DCT (MFCC 계산)
//                var mfccs = [Float](repeating: 0, count: melFilterBank.count)
//                dctSetup.transform(logMelEnergies, result: &mfccs)
//
//                // 7. 리프터링(Liftering)
//                let lifterCepstralCoefficients = 1 ... nMFCC
//                let lifter = lifterCepstralCoefficients.map { 1.0 + (Float(nMFCC) / 2.0) * sin(Float.pi * Float($0) / Float(nMFCC)) }
//
//                // --- 수정된 부분 시작 ---
//                // 클로저 외부의 'finalMfccs' 변수에 최종 결과를 할당한다.
//                vDSP_vmul(Array(mfccs.prefix(nMFCC)), 1, lifter, 1, &finalMfccs, 1, vDSP_Length(nMFCC))
//                // --- 수정된 부분 종료 ---
//            }
//        }
//
//        // 클로저 내에서 계산된 최종 결과를 반환한다.
//        return finalMfccs
//    }
//
//    /// 멜 필터뱅크를 생성하는 함수
//    func createMelFilterbank(nfft: Int, nfilts: Int, sampleRate: Float) -> [[Float]] {
//        let lowFreqMel = hertzToMel(300)
//        let highFreqMel = hertzToMel(sampleRate / 2)
//
//        // --- 수정된 부분 시작 ---
//        // stride의 to를 through로 변경하여 마지막 highFreqMel 값을 포함하도록 수정한다.
//        // 이렇게 하면 melPoints와 hertzPoints, bin 배열이 (nfilts + 2)개의 요소를 갖게 되어
//        // 루프의 마지막 반복에서 bin[i + 1]에 접근할 때 인덱스 오류가 발생하지 않는다.
//        let melPoints = stride(from: lowFreqMel, through: highFreqMel, by: (highFreqMel - lowFreqMel) / Float(nfilts + 1)).map { $0 }
//        // --- 수정된 부분 종료 ---
//
//        let hertzPoints = melPoints.map { melToHertz($0) }
//        let bin = hertzPoints.map { floor((Float(nfft) + 1) * $0 / sampleRate) }
//
//        var filters = [[Float]](repeating: [Float](repeating: 0, count: nfft / 2), count: nfilts)
//        for i in 1 ..< nfilts + 1 {
//            let f_m_minus = Int(bin[i - 1])
//            let f_m = Int(bin[i])
//            let f_m_plus = Int(bin[i + 1])
//
//            for j in f_m_minus ..< f_m {
//                if bin[i] - bin[i - 1] > 0 {
//                    filters[i - 1][j] = (Float(j) - bin[i - 1]) / (bin[i] - bin[i - 1])
//                }
//            }
//            for j in f_m ..< f_m_plus {
//                if bin[i + 1] - bin[i] > 0 {
//                    filters[i - 1][j] = (bin[i + 1] - Float(j)) / (bin[i + 1] - bin[i])
//                }
//            }
//        }
//        return filters
//    }
//
//    // 주파수-멜 스케일 변환 함수
//    private func hertzToMel(_ freq: Float) -> Float {
//        return 2595.0 * log10(1.0 + freq / 700.0)
//    }
//
//    private func melToHertz(_ mel: Float) -> Float {
//        return 700.0 * (pow(10.0, mel / 2595.0) - 1.0)
//    }
//}
