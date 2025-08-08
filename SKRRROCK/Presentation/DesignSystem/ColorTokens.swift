//
//  ColorTokens.swift
//  SKRRROCK
//
//  Created by 정희균 on 8/9/25.
//

import SwiftUI

enum ColorTokens {
  static let transparent: Color = Color.clear
  static let black: Color = Color.black
  static let white: Color = Color.white

  static let slate50: Color = Color(hex: "#F8FAFC")
  static let slate100: Color = Color(hex: "#F1F5F9")
  static let slate200: Color = Color(hex: "#E2E8F0")
  static let slate300: Color = Color(hex: "#CAD5E2")
  static let slate400: Color = Color(hex: "#90A1B9")
  static let slate500: Color = Color(hex: "#62748E")
  static let slate600: Color = Color(hex: "#45556C")
  static let slate700: Color = Color(hex: "#314158")
  static let slate800: Color = Color(hex: "#1D293D")
  static let slate900: Color = Color(hex: "#0F172B")

  static let red50: Color = Color(hex: "#FEF2F2")
  static let red100: Color = Color(hex: "#FFE2E2")
  static let red200: Color = Color(hex: "#FFC9C9")
  static let red300: Color = Color(hex: "#FFA2A2")
  static let red400: Color = Color(hex: "#FF6467")
  static let red500: Color = Color(hex: "#FB2C36")
  static let red600: Color = Color(hex: "#E7000B")
  static let red700: Color = Color(hex: "#C10007")
  static let red800: Color = Color(hex: "#9F0712")
  static let red900: Color = Color(hex: "#82181A")

  static let orange50: Color = Color(hex: "#FFF7ED")
  static let orange100: Color = Color(hex: "#FFEDD4")
  static let orange200: Color = Color(hex: "#FFD6A8")
  static let orange300: Color = Color(hex: "#FFB86A")
  static let orange400: Color = Color(hex: "#FF8904")
  static let orange500: Color = Color(hex: "#FF6900")
  static let orange600: Color = Color(hex: "#F54900")
  static let orange700: Color = Color(hex: "#CA3500")
  static let orange800: Color = Color(hex: "#9F2D00")
  static let orange900: Color = Color(hex: "#7E2A0C")

  static let yellow50: Color = Color(hex: "#FEFCE8")
  static let yellow100: Color = Color(hex: "#FEF9C2")
  static let yellow200: Color = Color(hex: "#FFF085")
  static let yellow300: Color = Color(hex: "#FFDF20")
  static let yellow400: Color = Color(hex: "#FDC700")
  static let yellow500: Color = Color(hex: "#F0B100")
  static let yellow600: Color = Color(hex: "#D08700")
  static let yellow700: Color = Color(hex: "#A65F00")
  static let yellow800: Color = Color(hex: "#894B00")
  static let yellow900: Color = Color(hex: "#733E0A")

  static let green50: Color = Color(hex: "#F0FDF4")
  static let green100: Color = Color(hex: "#DCFCE7")
  static let green200: Color = Color(hex: "#B9F8CF")
  static let green300: Color = Color(hex: "#7BF1A8")
  static let green400: Color = Color(hex: "#05DF72")
  static let green500: Color = Color(hex: "#00C950")
  static let green600: Color = Color(hex: "#00A63E")
  static let green700: Color = Color(hex: "#008236")
  static let green800: Color = Color(hex: "#016630")
  static let green900: Color = Color(hex: "#0D542B")

  static let blue50: Color = Color(hex: "#F0F9FF")
  static let blue100: Color = Color(hex: "#DFF2FE")
  static let blue200: Color = Color(hex: "#B8E6FE")
  static let blue300: Color = Color(hex: "#74D4FF")
  static let blue400: Color = Color(hex: "#00BCFF")
  static let blue500: Color = Color(hex: "#00A6F4")
  static let blue600: Color = Color(hex: "#0084D1")
  static let blue700: Color = Color(hex: "#0069A8")
  static let blue800: Color = Color(hex: "#00598A")
  static let blue900: Color = Color(hex: "#024A70")

  static let violet50: Color = Color(hex: "#F5F3FF")
  static let violet100: Color = Color(hex: "#EDE9FE")
  static let violet200: Color = Color(hex: "#DDD6FF")
  static let violet300: Color = Color(hex: "#C4B4FF")
  static let violet400: Color = Color(hex: "#A684FF")
  static let violet500: Color = Color(hex: "#8E51FF")
  static let violet600: Color = Color(hex: "#7F22FE")
  static let violet700: Color = Color(hex: "#7008E7")
  static let violet800: Color = Color(hex: "#5D0EC0")
  static let violet900: Color = Color(hex: "#4D179A")
}

#Preview {
  let colorGroups: [(name: String, colors: [(label: String, color: Color)])] = [
    (
      "Slate",
      [
        ("50", ColorTokens.slate50),
        ("100", ColorTokens.slate100),
        ("200", ColorTokens.slate200),
        ("300", ColorTokens.slate300),
        ("400", ColorTokens.slate400),
        ("500", ColorTokens.slate500),
        ("600", ColorTokens.slate600),
        ("700", ColorTokens.slate700),
        ("800", ColorTokens.slate800),
        ("900", ColorTokens.slate900),
      ]
    ),
    (
      "Red",
      [
        ("50", ColorTokens.red50),
        ("100", ColorTokens.red100),
        ("200", ColorTokens.red200),
        ("300", ColorTokens.red300),
        ("400", ColorTokens.red400),
        ("500", ColorTokens.red500),
        ("600", ColorTokens.red600),
        ("700", ColorTokens.red700),
        ("800", ColorTokens.red800),
        ("900", ColorTokens.red900),
      ]
    ),
    (
      "Orange",
      [
        ("50", ColorTokens.orange50),
        ("100", ColorTokens.orange100),
        ("200", ColorTokens.orange200),
        ("300", ColorTokens.orange300),
        ("400", ColorTokens.orange400),
        ("500", ColorTokens.orange500),
        ("600", ColorTokens.orange600),
        ("700", ColorTokens.orange700),
        ("800", ColorTokens.orange800),
        ("900", ColorTokens.orange900),
      ]
    ),
    (
      "Yellow",
      [
        ("50", ColorTokens.yellow50),
        ("100", ColorTokens.yellow100),
        ("200", ColorTokens.yellow200),
        ("300", ColorTokens.yellow300),
        ("400", ColorTokens.yellow400),
        ("500", ColorTokens.yellow500),
        ("600", ColorTokens.yellow600),
        ("700", ColorTokens.yellow700),
        ("800", ColorTokens.yellow800),
        ("900", ColorTokens.yellow900),
      ]
    ),
    (
      "Green",
      [
        ("50", ColorTokens.green50),
        ("100", ColorTokens.green100),
        ("200", ColorTokens.green200),
        ("300", ColorTokens.green300),
        ("400", ColorTokens.green400),
        ("500", ColorTokens.green500),
        ("600", ColorTokens.green600),
        ("700", ColorTokens.green700),
        ("800", ColorTokens.green800),
        ("900", ColorTokens.green900),
      ]
    ),
    (
      "Blue",
      [
        ("50", ColorTokens.blue50),
        ("100", ColorTokens.blue100),
        ("200", ColorTokens.blue200),
        ("300", ColorTokens.blue300),
        ("400", ColorTokens.blue400),
        ("500", ColorTokens.blue500),
        ("600", ColorTokens.blue600),
        ("700", ColorTokens.blue700),
        ("800", ColorTokens.blue800),
        ("900", ColorTokens.blue900),
      ]
    ),
    (
      "Violet",
      [
        ("50", ColorTokens.violet50),
        ("100", ColorTokens.violet100),
        ("200", ColorTokens.violet200),
        ("300", ColorTokens.violet300),
        ("400", ColorTokens.violet400),
        ("500", ColorTokens.violet500),
        ("600", ColorTokens.violet600),
        ("700", ColorTokens.violet700),
        ("800", ColorTokens.violet800),
        ("900", ColorTokens.violet900),
      ]
    ),
  ]

  ScrollView {
    VStack(alignment: .leading, spacing: 24) {
      ForEach(colorGroups, id: \.name) { group in
        VStack(alignment: .leading, spacing: 8) {
          Text(group.name)
            .font(.headline)
            .padding(.horizontal)

          ForEach(group.colors, id: \.label) { color in
            HStack {
              RoundedRectangle(cornerRadius: 6)
                .fill(color.color)
                .frame(width: 50, height: 30)
              Text("\(group.name.lowercased())\(color.label)")
                .font(.subheadline)
              Spacer()
            }
            .padding(.horizontal)
          }
        }
      }
    }
  }
}
