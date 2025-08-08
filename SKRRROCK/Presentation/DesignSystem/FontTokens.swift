//
//  FontTokens.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

enum FontTokens {
  static let goormSansBold: String = "goormSansOTF7"
  static let goormSansMedium: String = "goormSansOTF5"
  static let goormSansRegular: String = "goormSansOTF4"
  
  static let headingLgMedium: Font = .custom(goormSansMedium, size: 32)
  static let headingLgRegular: Font = .custom(goormSansRegular, size: 32)
  
  static let headingMdMedium: Font = .custom(goormSansMedium, size: 26)
  static let headingMdRegular: Font = .custom(goormSansRegular, size: 26)
  
  static let headingSmMedium: Font = .custom(goormSansMedium, size: 20)
  static let headingSmRegular: Font = .custom(goormSansRegular, size: 20)
  
  static let bodyLgMedium: Font = .custom(goormSansMedium, size: 17)
  static let bodyLgRegular: Font = .custom(goormSansRegular, size: 17)
  
  static let bodyMdMedium: Font = .custom(goormSansMedium, size: 14)
  static let bodyMdRegular: Font = .custom(goormSansRegular, size: 14)
  
  static let bodySmMedium: Font = .custom(goormSansMedium, size: 12)
  static let bodySmRegular: Font = .custom(goormSansRegular, size: 12)
}

#Preview {
  VStack {
    Text("headingLgMedium")
      .font(FontTokens.headingLgMedium)
    Text("headingLgRegular")
      .font(FontTokens.headingLgRegular)
    Text("headingMdMedium")
      .font(FontTokens.headingMdMedium)
    Text("headingMdRegular")
      .font(FontTokens.headingMdRegular)
    Text("headingSmMedium")
      .font(FontTokens.headingSmMedium)
    Text("headingSmRegular")
      .font(FontTokens.headingSmRegular)
    Text("bodyLgMedium")
      .font(FontTokens.bodyLgMedium)
    Text("bodyLgRegular")
      .font(FontTokens.bodyLgRegular)
    Text("bodyMdMedium")
      .font(FontTokens.bodyMdMedium)
    Text("bodyMdRegular")
      .font(FontTokens.bodyMdRegular)
    Text("bodySmMedium")
      .font(FontTokens.bodySmMedium)
    Text("bodySmRegular")
      .font(FontTokens.bodySmRegular)
  }
}
