//
//  DevToolModule.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

struct DevToolModule: Identifiable {
    let id = UUID()
    let title: String
    var models: [MMDevToolModel] = []
    var mainModel: MMDevToolModel = MMDevToolModel("", "", "", false)
    var moduleMainBool: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    mutating func addModel(_ model: MMDevToolModel) {
        models.append(model)
        models.sort { $0.featureName < $1.featureName }
    }
}

extension DevToolModule: Hashable {
    public static func == (lhs: DevToolModule, rhs: DevToolModule) -> Bool {
        return (lhs.title == rhs.title) && (lhs.models == rhs.models) && (lhs.id == rhs.id) && (lhs.mainModel == rhs.mainModel) && (lhs.moduleMainBool == rhs.moduleMainBool)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(models)
        hasher.combine(mainModel)
        hasher.combine(moduleMainBool)
    }
}
