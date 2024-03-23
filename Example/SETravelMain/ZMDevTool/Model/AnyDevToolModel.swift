//
//  AnyDevToolModel.swift
//  SETravel_Example
//
//  Created by Sam on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

public struct AnyDevToolModel: ModelType {
    public let model: ModelType

    public var businessName: String { return model.businessName }
    public var moduleName: String { return model.moduleName }
    public var featureName: String { return model.featureName }

    public var defaultData: ModelDefaultData { return model.defaultData }

    public init(model: ModelType) {
        self.model = model.model
    }
}

extension AnyDevToolModel: ModelClusterType {
    public var modelCluster: [AnyDevToolModel] {
        return [self]
    }
}

extension AnyDevToolModel: Equatable, Hashable {
    static public func ==(lhs: AnyDevToolModel, rhs: AnyDevToolModel) -> Bool {
        return lhs.modelIdentifier == rhs.modelIdentifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(modelIdentifier)
    }
}

public protocol ModelClusterType {
    var modelCluster: [AnyDevToolModel] { get }
}

public protocol ModelType: ModelClusterType {
    var model: ModelType { get }

    var businessName: String { get }
    var moduleName: String { get }
    var featureName: String { get }

    var defaultData: ModelDefaultData { get }
}

extension ModelType {
    var modelIdentifier: String {
        return "\(businessName)--\(moduleName)--\(featureName)"
    }
}
