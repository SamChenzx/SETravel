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
    var bzMainBoolValue: Bool = false {
        didSet {
            print("Sam dev:\(type(of: self)) line:\(#line) \(#function) title:\(title) value:\(bzMainBoolValue)")
        }
    }
    var mainModule: DevToolModule = DevToolModule(title: "")
    init(title: String) {
        self.title = title
        print("Sam dev:\(type(of: self)) line:\(#line) \(#function)")
    }
    
    mutating func addModule(_ module: DevToolModule) {
        if !modules.contains(where: { $0.title == module.title }) {
            modules.append(module)
        }
        modules.sort { $0.title < $1.title }
    }
    
    func findModule(by name: String) -> DevToolModule? {
        modules.first {
            $0.title == name
        }
    }
}

//extension DevToolBusiness: Hashable {
//    static func == (lhs: DevToolBusiness, rhs: DevToolBusiness) -> Bool {
//        return (lhs.title == rhs.title) && (lhs.modules == rhs.modules) && (lhs.bzMainBoolValue == rhs.bzMainBoolValue) && (lhs.mainModule == rhs.mainModule)
//    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(title)
//        hasher.combine(modules)
//        hasher.combine(mainModule)
//        hasher.combine(bzMainBoolValue)
//    }
//}

extension DevToolBusiness {

    internal var numberOfModels: Int {
        return modules.reduce(0) { $0 + $1.models.count }
    }

    internal var allModels: [MMDevToolModel] {
        return modules.reduce([]) {
            $0 + $1.models
        }
    }
}
