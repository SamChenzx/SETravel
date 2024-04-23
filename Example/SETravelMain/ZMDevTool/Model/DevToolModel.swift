//
//  DevToolModel.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

enum ModelNumValue {
    case int(Int)
    case float(Float)
    case double(Double)
}

public struct DevToolModel: Identifiable {
    public var id: String {
        modelIdentifier
    }
    var mainBool: Bool = false
    var businessName: String
    var moduleName: String
    var featureName: String
    var description: String?
    var dataValue: ModelDataValue {
        willSet {
            print("Sam dev:\(type(of: self)) line:\(#line) \(#function) newValue = \(newValue)")
        }
    }
    var minValue: ModelNumValue?
    var maxValue: ModelNumValue?
    var stepSize: ModelNumValue?
    var options: [String]?
    var modelIdentifier: String {
        return "\(businessName)--\(moduleName)--\(featureName)"
    }
    
    init(businessName: String, moduleName: String, featureName: String, dataValue: ModelDataValue, minValue: ModelNumValue? = nil, maxValue: ModelNumValue? = nil, stepSize: ModelNumValue? = nil, options: [String]? = nil) {
        self.businessName = businessName
        self.moduleName = moduleName
        self.featureName = featureName
        self.dataValue = dataValue
        self.minValue = minValue
        self.maxValue = maxValue
        self.stepSize = stepSize
        self.options = options
    }
    
    mutating func updateBool(_ boolValue: Bool) {
        self.dataValue = .boolean(currentValue: boolValue)
    }
}

extension DevToolModel: ModelIdentifiable {
    var persistenceIdentifier: String {
        return modelIdentifier+"|\(dataValue.codingKey)"
    }
}

extension DevToolModel: Hashable {
    
    public static func == (lhs: DevToolModel, rhs: DevToolModel) -> Bool {
        return (lhs.modelIdentifier == rhs.modelIdentifier) && (lhs.dataValue == rhs.dataValue)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(modelIdentifier)
        hasher.combine(dataValue)
    }
}

extension DevToolModel: ModelClusterType {
    public var modelCluster: [DevToolModel] {
        return [self]
    }
}

extension DevToolModel {
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, _ boolValue: Bool) {
        self.init(businessName: businessName, moduleName: moduleName, featureName: featureName, dataValue: .boolean(currentValue: boolValue))
    }
    
    public init<U: Numeric>(_ businessName: String, _ moduleName: String, _ featureName: String, _ value: U, minValue: U? = 0, maxValue: U? = 9999, stepSize: U? = 1) {
        var dataVal: ModelDataValue
        switch U.self {
        case is Int.Type:
            dataVal = .integer(currentValue: value as! Int, min: (minValue as? Int) ?? 0, max: (maxValue as? Int) ?? 9999, stepSize: (stepSize as? Int) ?? 1)
        case is Float.Type:
            dataVal = .float(currentValue: value as! CGFloat, min: (minValue as? CGFloat) ?? 0.0, max: (maxValue as? CGFloat) ?? 9999.9, stepSize: (stepSize as? CGFloat) ?? 1.0)
        case is Double.Type:
            dataVal = .double(currentValue: value as! Double, min: (minValue as? Double) ?? 0.0, max: (maxValue as? Double) ?? 9999.9, stepSize: (stepSize as? Double) ?? 1.0)
        default:
            dataVal = .float(currentValue: value as! CGFloat, min: (minValue as? CGFloat) ?? 0.0, max: (maxValue as? CGFloat) ?? 9999.9, stepSize: (stepSize as? CGFloat) ?? 1.0)
        }
        self.init(businessName: businessName, moduleName: moduleName, featureName: featureName, dataValue: dataVal)
    }

    public init(_ businessName: String, _ moduleName: String, _ featureName: String, _ colorValue: Color) {
        self.init(businessName: businessName, moduleName: moduleName, featureName: featureName, dataValue: .color(currentValue: colorValue))
    }
    
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, _ stringValue: String) {
        self.init(businessName: businessName, moduleName: moduleName, featureName: featureName, dataValue: .string(currentValue: stringValue))
    }
    
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, options: [String], defaultValue: String) {
        self.init(businessName: businessName, moduleName: moduleName, featureName: featureName, dataValue: .stringList(currentValue: StringOption(value: defaultValue), options: options.map { StringOption(value: $0) }))
    }
}



