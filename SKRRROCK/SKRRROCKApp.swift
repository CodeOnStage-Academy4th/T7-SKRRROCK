//
//  SKRRROCKApp.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/8/25.
//

import SwiftUI

@main
struct SKRRROCKApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            RecordPlayTestView(viewModel: DefaultRecordPlayTestViewModel())
        }
    }
}
