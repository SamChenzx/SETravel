//
//  DevToolStore.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public final class DevToolStore {
    var businessDictionary: [String: DevToolBusiness] = [:]
    private let storeName: String
    private let persistence: ModelPersistency
    private let allModels: Set<MMDevToolModel>
    init(models: [ModelClusterType], storeName: String = "ZMDev") {
        self.persistence = ModelPersistency(identifier: storeName)
        self.storeName = storeName
        self.allModels = Set(models.reduce([]) { $0 + $1.modelCluster})
        self.allModels.forEach { model in
            var business: DevToolBusiness
            if let existingBusiness = businessDictionary[model.businessName] {
                business = existingBusiness
            } else {
                business = DevToolBusiness(title: model.businessName)
                businessDictionary[business.title] = business
            }
            var module: DevToolModule
            if let existingModule = business.moduleDictionary[model.moduleName] {
                module = existingModule
            } else {
                module = DevToolModule(title: model.moduleName)
            }
            module.addModel(model)
            business.moduleDictionary[module.title] = module
            businessDictionary[business.title] = business
        }
    }

}

extension DevToolStore {
    internal var sortedBusinesses: [DevToolBusiness] {
        return businessDictionary
            .sorted { $0.0 < $1.0 }
            .map { return $0.1 }
    }
}



