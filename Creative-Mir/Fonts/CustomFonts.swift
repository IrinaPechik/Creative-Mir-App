//
//  CustomFonts.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.03.2024.
//

import SwiftUI

enum CustomFonts: String {
    case ManropeBold = "Manrope-Bold"
    case ManropeMedium = "Manrope-Medium"
    case LoraMedium = "Lora-Medium"
    case MarcellusRegular = "Marcellus-Regular"
    case LoraRegular = "Lora-Regular"
    case OpenSansLight = "OpenSans-Light"
    case OpenSansRegular = "OpenSans-Regular"
    case PlayfairDisplayMedium = "PlayfairDisplay-Medium"
    case FuturaPtLight = "Futura-pt-light"
}

extension Font {
    fileprivate static func custom(_ customFont: CustomFonts, size: CGFloat) -> Font {
            Font.custom(customFont.rawValue, size: size)
    }
}

extension Text {
    func font(customFont: CustomFonts, size: CGFloat) -> Text {
        self.font(Font.custom(customFont, size: size))
    }
}
