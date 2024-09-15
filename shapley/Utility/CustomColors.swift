//
//  CustomColors.swift
//  shapley
//
//  Created by Michael Campos on 8/7/24.
//

import Foundation
import SwiftUI

struct DisplayUserPallete {
    static let pallete1: [Color] = [Color.gunMetal, Color.prussianBlue, Color.violet, Color.roseTaupe]
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    // Palette 1
    static let maize = Color(hex: 0xFFE74C)
    static let brightPink = Color(hex: 0xFF5964)
    static let lapis = Color(hex: 0x38618C)
    static let argentinianBlue = Color(hex: 0x35A7FF)
    
    // Palette 2
    static let platinum = Color(hex: 0xCCDBDC)
    static let nonPhotoBlue = Color(hex: 0x9AD1D4)
    static let nonPhotoBlue2 = Color(hex: 0x80CED7)
    static let cerulean = Color(hex: 0x007EA7)
    
    // Palette 3
    static let silver = Color(hex: 0xBFB5AF)
    static let bone = Color(hex: 0xECE2D0)
    static let paleDogwood = Color(hex: 0xD5B9B2)
    static let roseTaupe = Color(hex: 0xA26769)
    static let violet = Color(hex: 0x582C4D)
    
    // Palette 5
    static let gunMetal = Color(hex: 0x22333B)
    static let almond = Color(hex: 0xEAE0D5)
    static let khaki = Color(hex: 0xC6AC8F)
    static let walnutBrown = Color(hex: 0x5E503F)
    static let prussianBlue = Color(hex: 0x003249)
}
