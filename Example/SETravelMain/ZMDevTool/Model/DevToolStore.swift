//
//  DevToolStore.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public final class DevToolStore {
    var businesses: [DevToolBusiness] = []
    private let storeName: String
    private let persistence: ModelPersistency
    private let allModels: Set<MMDevToolModel>
    init(models: [ModelClusterType], storeName: String = "ZMDev") {
        self.persistence = ModelPersistency(identifier: storeName)
        self.storeName = storeName
        self.allModels = Set(models.reduce([]) { $0 + $1.modelCluster})
        self.allModels.forEach { model in
            var business: DevToolBusiness
            if let existingBusiness = businesses.first(where: { $0.title == model.businessName }) {
                business = existingBusiness
            } else {
                business = DevToolBusiness(title: model.businessName)
                addBusiness(business)
            }
            var module: DevToolModule
            if let existingModule = business.findModule(by: model.moduleName) {
                module = existingModule
            } else {
                module = DevToolModule(title: model.moduleName)
            }
            module.addModel(model)
            business.addModule(module)
        }
    }
    
    func addBusiness(_ business: DevToolBusiness) {
        businesses.append(business)
        businesses.sort { $0.title < $1.title }
    }

}



