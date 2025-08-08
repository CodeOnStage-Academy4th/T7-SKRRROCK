//
//  SKRRROCKApp.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftData
import SwiftUI

@main
struct SKRRROCKApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TargetLearner.self, ShadowingRecord.self]) { result in
            switch result {
            case .success(let container):
                DefaultTargetLearnerSetup.setupDefaultLearners(context: container.mainContext)
            case .failure(let error):
                print("ModelContainer 생성 실패: \(error)")
            }
        }
    }
}
