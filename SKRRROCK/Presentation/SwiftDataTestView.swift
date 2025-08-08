//
//  SwiftDataTestView.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import SwiftUI
import SwiftData

struct SwiftDataTestView: View {
    @Environment(\.modelContext) private var context
    @Query private var targetLearners: [TargetLearner]
    
    var body: some View {
        NavigationView {
            List(targetLearners, id: \.id) { learner in
                NavigationLink(destination: LearnerScoreView(learner: learner)) {
                    HStack {
                        Text(learner.emoji)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text(learner.name)
                                .font(.headline)
                            Text("\(learner.shadowingRecords.count)명 도전")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("성대모사 러너들")
        }
    }
}

struct LearnerScoreView: View {
    let learner: TargetLearner
    @Environment(\.modelContext) private var context
    @State private var showingScoreInput = false
    
    var sortedRecords: [ShadowingRecord] {
        learner.shadowingRecords.sorted { $0.finalScore > $1.finalScore }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 러너 정보
            VStack {
                Text(learner.emoji)
                    .font(.system(size: 80))
                Text(learner.name)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            
            // 녹음하기 버튼
            Button("녹음하기 완료") {
                showingScoreInput = true
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // 점수현황판
            VStack(alignment: .leading) {
                Text("🏆 점수현황판")
                    .font(.headline)
                    .padding(.horizontal)
                
                List {
                    ForEach(Array(sortedRecords.enumerated()), id: \.element.id) { index, record in
                        HStack {
                            Text("\(index + 1)등")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .leading)
                            Text(record.userName)
                                .font(.headline)
                            Spacer()
                            Text("\(record.finalScore)점")
                                .font(.title3)
                                .bold()
                                .foregroundColor(index == 0 ? .gold : .primary)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
        .navigationTitle("\(learner.name) 점수판")
        .sheet(isPresented: $showingScoreInput) {
            ScoreInputSheet(learner: learner)
        }
    }
}

struct ScoreInputSheet: View {
    let learner: TargetLearner
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var userName: String = ""
    @State private var score: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("성대모사 결과")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                VStack(spacing: 15) {
                    TextField("이름을 입력하세요", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("점수 (0-100)", text: $score)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                }
                
                Button("저장") {
                    saveScore()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(userName.isEmpty || score.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(userName.isEmpty || score.isEmpty)
                
                Spacer()
            }
            .navigationTitle("점수 입력")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveScore() {
        guard let finalScore = Int(score), finalScore >= 0, finalScore <= 100 else { return }
        
        let repository = ShadowingRecordRepository(context: context)
        do {
            try repository.saveScore(userName: userName, targetLearner: learner, finalScore: finalScore)
            dismiss()
        } catch {
            print("점수 저장 실패: \(error)")
        }
    }
}

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

#Preview {
    SwiftDataTestView()
}