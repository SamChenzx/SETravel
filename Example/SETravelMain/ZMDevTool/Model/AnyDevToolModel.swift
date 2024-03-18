//
//  AnyDevToolModel.swift
//  SETravel_Example
//
//  Created by Sam on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

public struct AnyDevToolModel: AnyModel {
    public let model: AnyModel

    public var businessName: String { return model.businessName }
    public var moduleName: String { return model.moduleName }
    public var featureName: String { return model.featureName }

    public var defaultData: DefaultData { return model.defaultData }

    public init(model: AnyModel) {
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

public protocol AnyModel: ModelClusterType {
    var model: AnyModel { get }

    var businessName: String { get }
    var moduleName: String { get }
    var featureName: String { get }

    var defaultData: DefaultData { get }
}

extension AnyModel {
    var modelIdentifier: String {
        return "\(businessName)--\(moduleName)--\(featureName)"
    }
}

public enum DefaultData {
    case boolean(defaultValue: Bool)
    case integer(defaultValue: Int, min: Int?, max: Int?, stepSize: Int?)
    case float(defaultValue: CGFloat, min: CGFloat?, max: CGFloat?, stepSize: CGFloat?)
    case double(defaultValue: Double, min: Double?, max: Double?, stepSize: Double?)
    case color(defaultValue: Color)
    case string(defaultValue: String)
    case action(defaultValue: DevToolModelAction)
}
