//
//  BackButton.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

struct BackButton: View {
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Button {
        dismiss()
    } label: {
      Image(systemName: "chevron.backward")
        .foregroundStyle(.black)
        .frame(width: 44, height: 44)
        .background(.ultraThinMaterial, in: Circle())
    }
  }
}

#Preview {
  BackButton()
}
