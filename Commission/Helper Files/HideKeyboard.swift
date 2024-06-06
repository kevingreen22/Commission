//
//  HideKeyboard.swift
//  Commission
//
//  Created by Kevin Green on 5/8/21.
//

import SwiftUI
import UIKit

#if canImport(UIKit)
struct HideKeyboard: Gesture {
    var body: some Gesture {
        TapGesture()
            .onEnded { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}
#endif


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
