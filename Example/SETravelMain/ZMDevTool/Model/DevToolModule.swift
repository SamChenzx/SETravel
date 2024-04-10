//
//  DevToolModule.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

internal struct DevToolModule {
    let title: String
    var models: [String: MMDevToolModel] = [:]

    init(title: String) {
        self.title = title
    }
}

extension DevToolModule {
    internal var sortedModels: [MMDevToolModel] {
        return models.sorted { $0.0 < $1.0 }.map { return $0.1 }
    }
}
