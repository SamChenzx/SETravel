//
//  BindingExtension.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/12.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
