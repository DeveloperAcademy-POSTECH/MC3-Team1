//
//  Color+.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/27.
//

import Foundation
import SwiftUI

extension Color {
    static let primary: Color = Color("Primary")
    static let complementary: Color = Color("Complementary")
    
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    
}
