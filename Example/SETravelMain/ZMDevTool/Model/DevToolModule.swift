//
//  DevToolModule.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

internal struct DevToolModule: Identifiable {
    let id = UUID()
    let title: String
    var models: [MMDevToolModel] = []
    
    init(title: String) {
        self.title = title
    }
    
    mutating func addModel(_ model: MMDevToolModel) {
        models.append(model)
        models.sort { $0.featureName < $1.featureName }
    }
}
