//
//  DevToolBusiness.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import Dispatch

struct DevToolBusiness {
    let title: String
    var modules: [DevToolModule] = []
    init(title: String) {
        self.title = title
    }
    
    fileprivate mutating func addModule(_ module: DevToolModule) {
        if !modules.contains(where: { $0.title == module.title }) {
            modules.append(module)
        }
        modules.sort { $0.title < $1.title }
    }
    
    mutating func updateModule(_ module: DevToolModule) {
        if (findModule(by: module.title) != nil) {
            modules.removeAll { $0.title == module.title }
        }
        addModule(module)
    }
    
    func findModule(by name: String) -> DevToolModule? {
        modules.first {
            $0.title == name
        }
    }
}

extension DevToolBusiness {

    internal var numberOfModels: Int {
        return modules.reduce(0) { $0 + $1.models.count }
    }

    internal var allModels: [DevToolModel] {
        return modules.reduce([]) {
            $0 + $1.models
        }
    }
}
