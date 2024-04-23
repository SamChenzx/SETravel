//
//  DevToolStore.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public final class DevToolStore: ObservableObject {
    @Published var businesses: [String: DevToolBusiness] = [:]
    @Published var allBusinessesTitles: [String] = []
    private let storeName: String
    private let persistence: ModelPersistency
    private let allModels: Set<DevToolModel>
    init(models: [ModelClusterType], storeName: String = "ZMDev") {
        self.persistence = ModelPersistency(identifier: storeName)
        self.storeName = storeName
        self.allModels = Set(models.reduce([]) { $0 + $1.modelCluster})
        self.allModels.forEach { model in
            var business: DevToolBusiness
            if let existingBusiness = businesses[model.businessName] {
                business = existingBusiness
            } else {
                business = DevToolBusiness(title: model.businessName)
            }
            var module: DevToolModule
            if let existingModule = business.findModule(by: model.moduleName) {
                module = existingModule
            } else {
                module = DevToolModule(title: model.moduleName)
            }
            module.addModel(model)
            business.updateModule(module)
            businesses[model.businessName] = business
        }
        let sortedPair = businesses.sorted {$0.key < $1.key}
        self.allBusinessesTitles = sortedPair.map { $0.0 }
    }
    
    func updateModel(_ model: DevToolModel) {
        
    }
    
}



