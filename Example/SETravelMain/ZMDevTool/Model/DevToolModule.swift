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
    var models: [DevToolModel] = []
    
    init(title: String) {
        self.title = title
    }
    
    @discardableResult
    mutating func addModel(_ model: DevToolModel) -> DevToolModule {
        models.append(model)
        models.sort { $0.featureName < $1.featureName }
        return self
    }
    
    @discardableResult
    mutating func updateModel(_ model: DevToolModel) -> DevToolModule {
        models.removeAll { $0.featureName == model.featureName }
        return addModel(model)
    }
}

extension DevToolModule: Hashable {
    public static func == (lhs: DevToolModule, rhs: DevToolModule) -> Bool {
        return (lhs.title == rhs.title) && (lhs.models == rhs.models) && (lhs.id == rhs.id)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(models)
    }
}
