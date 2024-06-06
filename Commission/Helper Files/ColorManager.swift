//
//  ColorManager.swift
//  Comish
//
//  Created by Kevin Green on 10/2/20.
//

import SwiftUI

struct ColorManager {
    static let lightGray = Color("light_gray")
    static let lightPink = Color("light_pink")
    static let lightPurple = Color("light_purple")
    static let opaqueWhite = Color(.white).opacity(0.5)
    static let mainDark = Color("main_dark")
    static let secondDark = Color("second_dark")
    static let shadow = Color("shadow")
    static let mainText = Color("main_text")
    
    
    static let mainBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ColorManager.secondDark, ColorManager.mainDark]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let mainBackgroundGradientReversed = LinearGradient(gradient: Gradient(colors: [ColorManager.mainDark, ColorManager.secondDark]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let secondaryGradient = LinearGradient(gradient: Gradient(colors: [ColorManager.lightPink, ColorManager.lightPurple]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    
    
    static let serviceGridGradientMask = LinearGradient(gradient: Gradient(colors: [Color.clear, ColorManager.opaqueWhite]), startPoint: .topLeading, endPoint: .trailing)
    
    
    
    static var gradientBackgroundLayer: CAGradientLayer {
        let colors = [UIColor(Self.secondDark).cgColor, UIColor(Self.mainDark).cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]

        let gradientLayer = CAGradientLayer()
        gradientLayer .colors = colors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

