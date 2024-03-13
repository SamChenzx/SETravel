//
//  DevToolModel.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public struct DevToolModel<T: DevToolType> {
    let businessName: String
    let moduleName: String
    let featureName: String
    let defaultValue: T
    
    init(businessName: String, moduleName: String, featureName: String, defaultValue: DevToolType) {
        self.businessName = businessName
        self.moduleName = moduleName
        self.featureName = featureName
        self.defaultValue = defaultValue
    }
}
