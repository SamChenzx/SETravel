//
//  AnyDevToolModel.swift
//  SETravel_Example
//
//  Created by Sam on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

public struct AnyDevToolModel {
    public var dataValue: ModelDataValue {
        get {
            return model.dataValue
        }
        set(newDataValue) {
            model.dataValue = newDataValue
        }
    }
    public var model: ModelType

    public var businessName: String { return model.businessName }
    public var moduleName: String { return model.moduleName }
    public var featureName: String { return model.featureName }

    public init(model: ModelType) {
        self.model = model.model
    }
}

//extension AnyDevToolModel: Equatable, Hashable {
//    static public func ==(lhs: AnyDevToolModel, rhs: AnyDevToolModel) -> Bool {
//        return lhs.modelIdentifier == rhs.modelIdentifier
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(modelIdentifier)
//    }
//}
//
//extension AnyDevToolModel: ModelIdentifiable, Identifiable {
//    public var id: Self { self }
//    
//    var persistenceIdentifier: String {
//        return modelIdentifier+"|\(dataValue.codingKey)"
//    }
//}

public protocol ModelClusterType {
    var modelCluster: [DevToolModel] { get }
}

public protocol ModelType: ModelClusterType {
    var model: ModelType { get }

    var businessName: String { get }
    var moduleName: String { get }
    var featureName: String { get }

    var dataValue: ModelDataValue { get set }
}

extension ModelType {
    var modelIdentifier: String {
        return "\(businessName)--\(moduleName)--\(featureName)"
    }
}
