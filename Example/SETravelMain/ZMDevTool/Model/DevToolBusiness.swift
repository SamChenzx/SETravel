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
    var modules: [String: DevToolModule] = [:]

    init(title: String) {
        self.title = title
    }
}

extension DevToolBusiness {
    internal var sortedModules: [DevToolModule] {
        return modules
            .sorted { $0.0 < $1.0 }
            .map { return $0.1 }
    }

    internal var numberOfModels: Int {
        return sortedModules.reduce(0) { $0 + $1.sortedModels.count }
    }

    internal var allModels: [AnyDevToolModel] {
        return sortedModules.reduce([]) {
            $0 + $1.sortedModels
        }
    }
}
