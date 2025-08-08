//
//  Text+Extension.swift
//  SKRRROCK
//
//  Created by Jun on 8/9/25.
//

import Foundation
import SwiftUI

extension Text {
    func stroke(_ color: Color, lineWidth: CGFloat) -> some View {
        self
            .background(
                ZStack {
                    self.offset(x: -lineWidth, y: -lineWidth).foregroundColor(
                        color
                    )
                    self.offset(x: lineWidth, y: -lineWidth).foregroundColor(
                        color
                    )
                    self.offset(x: -lineWidth, y: lineWidth).foregroundColor(
                        color
                    )
                    self.offset(x: lineWidth, y: lineWidth).foregroundColor(
                        color
                    )
                    self.offset(x: 0, y: -lineWidth).foregroundColor(color)
                    self.offset(x: 0, y: lineWidth).foregroundColor(color)
                    self.offset(x: -lineWidth, y: 0).foregroundColor(color)
                    self.offset(x: lineWidth, y: 0).foregroundColor(color)
                }
            )
    }
}
