//
//  DevToolBusiness.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

internal struct DevToolBusiness {
    let title: String
    var moduleDictionary: [String: DevToolModule] = [:]

    init(title: String) {
        self.title = title
    }
}

extension DevToolBusiness {
    internal var sortedModules: [DevToolModule] {
        return moduleDictionary
            .sorted { $0.0 < $1.0 }
            .map { return $0.1 }
    }

    internal var numberOfModels: Int {
        return sortedModules.reduce(0) { $0 + $1.models.count }
    }

    internal var allModels: [MMDevToolModel] {
        return sortedModules.reduce([]) {
            $0 + $1.models
        }
    }
}
