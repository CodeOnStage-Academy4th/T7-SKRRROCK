//
//  LaughAnalyzerDev.swift
//  SKRRROCK
//
//  Created by 김현기 on 8/9/25.
//

// LaughAnalyzerDev.swift

import Accelerate
import AVFoundation
import SwiftUI

struct LaughAnalysisResult {
    var volumeData: [Float] = []
    var pitchData: [Float] = []
    var laughSpeed: Float = 0.0
    var mfccData: [[Float]] = [] // MFCC 데이터를 저장할 속성 추가
}

@Observable
class LaughAnalyzerDev {
    private var audioPlayer: AVAudioPlayer?
    private let engine = AVAudioEngine()

    var targetResult: LaughAnalysisResult = .init()
    var userResult: LaughAnalysisResult = .init()

    private var sampleRate: Double = 44100.0
    private let rmsThreshold: Float = 0.01

    /// 로컬 오디오 파일을 분석합니다.
    func analyzeLaugh(url: URL, isTarget: Bool = true) throws {
        let file = try AVAudioFile(forReading: url)
        let format = file.processingFormat
        sampleRate = format.sampleRate
        let frameCount = AVAudioFrameCount(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        try file.read(into: buffer)

        // --- [디버깅 로그 1] ---
        // 분석 시작과 함께 오디오 파일의 기본 정보를 출력한다.
        print("---  Laugh Analysis Started ---")
        print("Target Audio: \(url.lastPathComponent)")
        print("Sample Rate: \(sampleRate), Total Frames: \(frameCount)")
        print("------------------------------------")

        // 결과 초기화
        DispatchQueue.main.async {
            if isTarget {
                self.targetResult = .init()
            } else {
                self.userResult = .init()
            }
        }

        let step = 2048
        let totalFrames = Int(buffer.frameLength)
        guard let channelData = buffer.floatChannelData?[0] else { return }

//        // --- MFCC 계산 설정 활성화 ---
//        let nMFCC = 13 // 추출할 MFCC 계수 개수
//        let nFFT = 2048 // FFT 윈도우 크기
//        let melFilterBank = createMelFilterbank(nfft: nFFT, nfilts: 40, sampleRate: Float(sampleRate))
//        print("--- Mel Filter Bank Created ---")
//        guard let dctSetup = vDSP_DCT_CreateSetup(nil,
//                                                  vDSP_Length(40),
//                                                  .II) else { return }
//        print("--- DCT Setup Created ---")
//        // --- 수정된 부분 종료 ---

        var tempVolumeData: [Float] = []
        var tempPitchData: [Float] = []
        var tempMfccData: [[Float]] = [] // MFCC 임시 저장 배열 활성화

        for start in stride(from: 0, to: totalFrames, by: step) {
            let length = min(step, totalFrames - start)
            let subBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(length))!
            subBuffer.frameLength = AVAudioFrameCount(length)
            memcpy(subBuffer.floatChannelData![0], channelData.advanced(by: start), length * MemoryLayout<Float>.size)

            let rms = calculateRMS(buffer: subBuffer)
            let pitch: Float = (rms > rmsThreshold) ? calculatePitch(buffer: subBuffer, sampleRate: sampleRate) : 0

//            // --- MFCC 계산 로직 활성화 ---
//            var mfcc: [Float] = []
//            if rms > rmsThreshold { // 유의미한 소리일 때만 MFCC 계산
//                mfcc = calculateMFCC(buffer: subBuffer, nMFCC: nMFCC, nFFT: nFFT, melFilterBank: melFilterBank, dctSetup: dctSetup)
//            }
//
//            // --- [디버깅 로그 2] ---
//            // 각 프레임(step)마다 계산된 주요 값들을 출력한다.
//            // 값이 너무 많이 출력될 경우, if start % (step * 10) == 0 { ... } 와 같이 조건을 추가하여 로그 빈도를 조절할 수 있다.
//            print("Frame \(start / step): RMS = \(String(format: "%.4f", rms)), Pitch = \(String(format: "%.2f", pitch))")
//            if !mfcc.isEmpty {
//                // MFCC 벡터의 첫 3개 값만 샘플로 출력하여 간결하게 확인한다.
//                let mfccPreview = mfcc.prefix(3).map { String(format: "%.2f", $0) }.joined(separator: ", ")
//                print("  -> MFCC: [\(mfccPreview), ...]")
//            }

            tempVolumeData.append(rms)
            tempPitchData.append(pitch)

            // MFCC 결과가 비어있지 않을 때만 추가
//            if !mfcc.isEmpty {
//                tempMfccData.append(mfcc)
//            }
        }

        let finalLaughSpeed = calculateLaughSpeed(from: tempVolumeData, step: step)

        // --- [디버깅 로그 3] ---
        // 모든 프레임 분석 완료 후, 최종 결과가 저장되기 직전의 상태를 요약하여 출력한다.
        print("------------------------------------")
        print("--- Laugh Analysis Finished ---")
        print("Total Volume Frames: \(tempVolumeData.count)")
        print("Total Pitch Frames: \(tempPitchData.count)")
        print("Total MFCC Vectors: \(tempMfccData.count)")
        print("Calculated Laugh Speed: \(String(format: "%.2f", finalLaughSpeed)) Hz")
        print("------------------------------------")

        // 분석 결과 한 번에 업데이트
        DispatchQueue.main.async {
            if isTarget {
                self.targetResult.volumeData = tempVolumeData
                self.targetResult.pitchData = tempPitchData
                self.targetResult.mfccData = tempMfccData // MFCC 결과 저장 활성화
                self.targetResult.laughSpeed = finalLaughSpeed
            } else {
                self.userResult.volumeData = tempVolumeData
                self.userResult.pitchData = tempPitchData
                self.userResult.mfccData = tempMfccData // MFCC 결과 저장 활성화
                self.userResult.laughSpeed = finalLaughSpeed
            }
        }
    }

    /// Data 타입의 오디오 데이터를 분석합니다.
    func analyzeLaugh(data: Data) throws {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
        try data.write(to: tempURL)
        defer { try? FileManager.default.removeItem(at: tempURL) }
        try analyzeLaugh(url: tempURL, isTarget: false)
    }

    // 이하 기존 함수들 (calculateRMS, calculatePitch, calculateLaughSpeed)은 변경 없음...
    private func calculateRMS(buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData?[0] else { return 0 }
        let frameLength = Int(buffer.frameLength)
        var sumSquares: Float = 0
        vDSP_svesq(channelData, 1, &sumSquares, vDSP_Length(frameLength))
        return sqrt(sumSquares / Float(frameLength))
    }

    private func calculatePitch(buffer: AVAudioPCMBuffer, sampleRate: Double) -> Float {
        guard let channelData = buffer.floatChannelData?[0] else { return 0 }
        let frameLength = Int(buffer.frameLength)
        var window = [Float](repeating: 0, count: frameLength)
        vDSP_hamm_window(&window, vDSP_Length(frameLength), 0)
        var windowedData = [Float](repeating: 0, count: frameLength)
        vDSP_vmul(channelData, 1, window, 1, &windowedData, 1, vDSP_Length(frameLength))
        var autocorr = [Float](repeating: 0, count: frameLength)
        vDSP_conv(windowedData, 1,
                  windowedData, 1,
                  &autocorr, 1,
                  vDSP_Length(frameLength),
                  vDSP_Length(frameLength))
        var maxAutocorr: Float = 0
        vDSP_maxmgv(autocorr, 1, &maxAutocorr, vDSP_Length(frameLength))
        guard maxAutocorr > 0 else { return 0 }
        vDSP_vsdiv(autocorr, 1, &maxAutocorr, &autocorr, 1, vDSP_Length(frameLength))
        let minLag = Int(sampleRate / 2000)
        let maxLag = min(Int(sampleRate / 70), frameLength - 1)
        guard maxLag > minLag else { return 0 }
        let peakIndex = (minLag ... maxLag).max(by: { autocorr[$0] < autocorr[$1] }) ?? 0
        guard peakIndex > 0 else { return 0 }
        let pitchVal = Float(sampleRate) / Float(peakIndex)
        return (pitchVal < 70 || pitchVal > 2000) ? 0 : pitchVal
    }

    private func calculateLaughSpeed(from rmsData: [Float], step: Int) -> Float {
        guard rmsData.count > 2 else { return 0 }
        let mean = rmsData.reduce(0, +) / Float(rmsData.count)
        let threshold = mean * 1.1

        var peaks: [Int] = []
        var lastPeak = -1000
        let minInterval = Int((sampleRate * 0.08) / Double(step))

        for i in 1 ..< rmsData.count - 1 {
            if rmsData[i] > threshold &&
                rmsData[i] > rmsData[i - 1] &&
                rmsData[i] > rmsData[i + 1] &&
                (i - lastPeak) > minInterval
            {
                peaks.append(i)
                lastPeak = i
            }
        }
        if peaks.count < 2 { return 0 }
        let intervals = zip(peaks, peaks.dropFirst()).map { Float($1 - $0) * Float(step) / Float(sampleRate) }
        return 1.0 / (intervals.reduce(0, +) / Float(intervals.count))
    }

    func calculateMFCC(buffer: AVAudioPCMBuffer, nMFCC: Int, nFFT: Int, melFilterBank: [[Float]], dctSetup: vDSP.DCT) -> [Float] {
        guard let channelData = buffer.floatChannelData?[0] else { return [] }
        var samples = [Float](UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))

        // 1. 프레이밍 및 윈도잉
        if samples.count < nFFT {
            samples += [Float](repeating: 0, count: nFFT - samples.count)
        }
        var window = [Float](repeating: 0, count: nFFT)
        vDSP_hamm_window(&window, vDSP_Length(nFFT), 0)
        vDSP_vmul(samples, 1, window, 1, &samples, 1, vDSP_Length(nFFT))

        // 2. FFT (고속 푸리에 변환)
        let log2n = vDSP_Length(log2(Float(nFFT)))
        guard let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2)) else { return [] }
        defer { vDSP_destroy_fftsetup(fftSetup) }

        var realp = [Float](repeating: 0, count: nFFT / 2)
        var imagp = [Float](repeating: 0, count: nFFT / 2)

        // --- 최종 반환 값을 저장할 변수 ---
        var finalMfccs = [Float](repeating: 0, count: nMFCC)

        realp.withUnsafeMutableBufferPointer { realpBuffer in
            imagp.withUnsafeMutableBufferPointer { imagpBuffer in
                var splitComplex = DSPSplitComplex(realp: realpBuffer.baseAddress!, imagp: imagpBuffer.baseAddress!)

                samples.withUnsafeBufferPointer { samplesBuffer in
                    let unsafePtr = UnsafeRawPointer(samplesBuffer.baseAddress!).bindMemory(to: DSPComplex.self, capacity: nFFT)
                    vDSP_ctoz(unsafePtr, 2, &splitComplex, 1, vDSP_Length(nFFT / 2))
                }

                vDSP_fft_zrip(fftSetup, &splitComplex, 1, log2n, Int32(FFT_FORWARD))

                // 3. 파워 스펙트럼
                var magnitudes = [Float](repeating: 0, count: nFFT / 2)
                vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(nFFT / 2))

                // 4. 멜 필터뱅크 적용
                let flattenedFilters = melFilterBank.flatMap { $0 }
                var melEnergies = [Float](repeating: 0, count: melFilterBank.count)
                vDSP_mmul(magnitudes, 1, flattenedFilters, 1, &melEnergies, 1, 1, vDSP_Length(melFilterBank.count), vDSP_Length(nFFT / 2))

                // 5. 로그 에너지
                var logMelEnergies = [Float](repeating: 0, count: melFilterBank.count)
                var initialPower: Float = 1.0
                vDSP_vdbcon(melEnergies, 1, &initialPower, &logMelEnergies, 1, vDSP_Length(melFilterBank.count), 1)

                // 6. DCT (MFCC 계산)
                var mfccs = [Float](repeating: 0, count: melFilterBank.count)
                dctSetup.transform(logMelEnergies, result: &mfccs)

                // 7. 리프터링(Liftering)
                let lifterCepstralCoefficients = 1 ... nMFCC
                let lifter = lifterCepstralCoefficients.map { 1.0 + (Float(nMFCC) / 2.0) * sin(Float.pi * Float($0) / Float(nMFCC)) }

                // --- 수정된 부분 시작 ---
                // 클로저 외부의 'finalMfccs' 변수에 최종 결과를 할당한다.
                vDSP_vmul(Array(mfccs.prefix(nMFCC)), 1, lifter, 1, &finalMfccs, 1, vDSP_Length(nMFCC))
                // --- 수정된 부분 종료 ---
            }
        }

        // 클로저 내에서 계산된 최종 결과를 반환한다.
        return finalMfccs
    }

    /// 멜 필터뱅크를 생성하는 함수
    func createMelFilterbank(nfft: Int, nfilts: Int, sampleRate: Float) -> [[Float]] {
        let lowFreqMel = hertzToMel(300)
        let highFreqMel = hertzToMel(sampleRate / 2)

        // --- 수정된 부분 시작 ---
        // stride의 to를 through로 변경하여 마지막 highFreqMel 값을 포함하도록 수정한다.
        // 이렇게 하면 melPoints와 hertzPoints, bin 배열이 (nfilts + 2)개의 요소를 갖게 되어
        // 루프의 마지막 반복에서 bin[i + 1]에 접근할 때 인덱스 오류가 발생하지 않는다.
        let melPoints = stride(from: lowFreqMel, through: highFreqMel, by: (highFreqMel - lowFreqMel) / Float(nfilts + 1)).map { $0 }
        // --- 수정된 부분 종료 ---

        let hertzPoints = melPoints.map { melToHertz($0) }
        let bin = hertzPoints.map { floor((Float(nfft) + 1) * $0 / sampleRate) }

        var filters = [[Float]](repeating: [Float](repeating: 0, count: nfft / 2), count: nfilts)
        for i in 1 ..< nfilts + 1 {
            let f_m_minus = Int(bin[i - 1])
            let f_m = Int(bin[i])
            let f_m_plus = Int(bin[i + 1])

            for j in f_m_minus ..< f_m {
                if bin[i] - bin[i - 1] > 0 {
                    filters[i - 1][j] = (Float(j) - bin[i - 1]) / (bin[i] - bin[i - 1])
                }
            }
            for j in f_m ..< f_m_plus {
                if bin[i + 1] - bin[i] > 0 {
                    filters[i - 1][j] = (bin[i + 1] - Float(j)) / (bin[i + 1] - bin[i])
                }
            }
        }
        return filters
    }

    // 주파수-멜 스케일 변환 함수
    private func hertzToMel(_ freq: Float) -> Float {
        return 2595.0 * log10(1.0 + freq / 700.0)
    }

    private func melToHertz(_ mel: Float) -> Float {
        return 700.0 * (pow(10.0, mel / 2595.0) - 1.0)
    }
}
