//
//  Modifiers.swift
//  Comish
//
//  Created by Kevin Green on 2/19/21.
//

import SwiftUI
import Combine


/// Creates a drop shadow
/// - Parameters:
///   - color:      The color of the shadow, default is a dark gray.
///   - radius:     The spread radius of the shadow, default is 10.
///   - xOffset:    The x offset, default is 0.
///   - yOffset:    The y offset, default is -5 if isDroped is true, 5 otherwise.
///   - isDroped:   A boolean deciding weather the shadow is droped or lifted, default is true.
struct Shadow: ViewModifier {
    var color: Color = ColorManager.shadow
    var radius: CGFloat = 10
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = -5
    var isDroped: Bool = true
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 10, x: 0, y: isDroped ? 5 : -5)
    }
}


struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.largeTitle)
            .padding([.horizontal, .bottom])
            .foregroundColor(.gray)
            .accentColor(ColorManager.mainDark)
    }
}


struct LabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top)
            .font(.title2)
    }
}


struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    var color: Color
    var alignment: Alignment
    
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            if show { placeHolder }
            content
                .foregroundColor(color)
        }
    }
}
