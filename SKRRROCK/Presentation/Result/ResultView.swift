//
//  ResultView.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftUI

struct ResultView: View {
    @State private var viewModel: ResultViewModel

    init(viewModel: ResultViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            //TODO: 배경색 변경 필요
            Color.black
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Image("scoreBackground")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 90)
                    
                    VStack {
                        Text("SCORE")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                
                        
                        Text("\(viewModel.score)")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(hex: "0900FF"), location: 0.0),
                                        .init(color: Color(hex: "FF00FB"), location: 0.5),
                                        .init(color: Color(hex: "00A6FF"), location: 1.0)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                          
                            
                    }
                }
                
                // MARK: 점수대 별 멘트 
                VStack(spacing: 4) {
                    Text(viewModel.getFirstMessage())
                        .font(.system(size: 32, weight: .medium))
                    Text(viewModel.getSecondMessage())
                        .font(.system(size: 20, weight: .regular))
                }
                .foregroundColor(.white)
                
                Image(viewModel.getDanceImageName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256)
                
                
                HStack{
                    //TODO: 버튼 컴포넌트 이용해서 다시하기 / 랭킹 등록 만들어야함
                }
            }
        }
    }
}

#Preview {
    let viewModel = DefaultResultViewModel()
    viewModel.score = 36
    viewModel.targetLearnerName = "광로"
    return ResultView(viewModel: viewModel)
}
