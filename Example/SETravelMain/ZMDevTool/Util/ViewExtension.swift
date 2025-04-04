//
//  ViewExtension.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/19.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}

extension EnvironmentValues {
    var keyboardIsShown: Bool {
        get { return self[KeyboardIsShownEVK.self] }
        set { self[KeyboardIsShownEVK.self] = newValue }
    }
}

private struct KeyboardIsShownEVK: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct HideKeyboardGestureModifier: ViewModifier {
    @Environment(\.keyboardIsShown) var keyboardIsShown
    
    func body(content: Content) -> some View {
        content
            .gesture(TapGesture().onEnded {
                UIApplication.shared.resignCurrentResponder()
            }, including: keyboardIsShown ? .all : .none)
    }
}

extension UIApplication {
    func resignCurrentResponder() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}

extension View {

    /// Assigns a tap gesture that dismisses the first responder only when the keyboard is visible to the KeyboardIsShown EnvironmentKey
    func dismissKeyboardOnTap() -> some View {
        modifier(HideKeyboardGestureModifier())
    }
    
    /// Shortcut to close in a function call
    func resignCurrentResponder() {
        UIApplication.shared.resignCurrentResponder()
    }
}




