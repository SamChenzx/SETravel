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

public struct MMDevToolModel: Identifiable {
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

extension MMDevToolModel: ModelIdentifiable {
    var persistenceIdentifier: String {
        return modelIdentifier+"|\(dataValue.codingKey)"
    }
}

extension MMDevToolModel: Hashable {
    
    public static func == (lhs: MMDevToolModel, rhs: MMDevToolModel) -> Bool {
        return (lhs.modelIdentifier == rhs.modelIdentifier) && (lhs.dataValue == rhs.dataValue)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(modelIdentifier)
        hasher.combine(dataValue)
    }
}

extension MMDevToolModel: ModelClusterType {
    public var modelCluster: [MMDevToolModel] {
        return [self]
    }
}

extension MMDevToolModel {
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

public struct DevToolModel<T: BaseType> {
    public let businessName: String
    public let moduleName: String
    public let featureName: String
    internal var defaultValue: T
    internal let minimumValue: T?
    internal let maximumValue: T?
    internal let stepSize: T?
    internal let options: [T]?
    
    internal init(businessName: String, moduleName: String, featureName: String, defaultValue: T, minimumValue: T? = nil, maximumValue: T? = nil, stepSize: T? = nil, options: [T]? = nil) {
        self.businessName = businessName
        self.moduleName = moduleName
        self.featureName = featureName
        self.defaultValue = defaultValue
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.stepSize = stepSize
        self.options = options
    }
}

extension DevToolModel {
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, _ defaultValue: T) {
        self.init(
            businessName: businessName,
            moduleName: moduleName,
            featureName: featureName,
            defaultValue: defaultValue
        )
    }
    
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, _ defaultValueProvider: () -> T) {
        self.init(
            businessName: businessName,
            moduleName: moduleName,
            featureName: featureName,
            defaultValue: defaultValueProvider()
        )
    }
}

extension DevToolModel where T: Comparable {
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, defaultValue: T, min minimumValue: T? = nil, max maximumValue: T? = nil, stepSize: T? = nil) {

        // Assert that the model's defaultValue is between its min and max (if they exist)
        if clip(defaultValue, minimumValue, maximumValue) != defaultValue {
            assertionFailure("A model's default value must be between its min and max. Your feature \"\(featureName)\" doesn't meet this requirement.")
        }
        self.init(
            businessName: businessName,
            moduleName: moduleName,
            featureName: featureName,
            defaultValue: defaultValue,
            minimumValue: minimumValue,
            maximumValue: maximumValue,
            stepSize: stepSize
        )
    }
}

extension DevToolModel where T == StringOption {
    public init(_ businessName: String, _ moduleName: String, _ featureName: String, options: [String], defaultValue: String? = nil) {
        precondition(!options.isEmpty, "Options list cannot be empty (stringList tweak \"\(featureName)\")")
        precondition(
            defaultValue == nil || options.contains(defaultValue!),
            "The default value \"\(String(describing: defaultValue))\" of the stringList tweak \"\(featureName)\" must be in the list of options \"\(options)\""
        )

        self.init(
            businessName: businessName,
            moduleName: moduleName,
            featureName: featureName,
            defaultValue: StringOption(value: defaultValue ?? options[0]),
            options: options.map(StringOption.init)
        )
    }
}

extension DevToolModel {
    public static func stringList(_ businessName: String, _ moduleName: String, _ featureName: String, options: [String], defaultValue: String? = nil) -> DevToolModel<StringOption> {
        
        return DevToolModel<StringOption>(
            businessName,
            moduleName,
            featureName,
            options: options,
            defaultValue: defaultValue
        )
    }
}

extension DevToolModel {
    public var dataValue: ModelDataValue {
        get {
            switch T.dataType {
            case .boolean:
                return .boolean(currentValue: (defaultValue as! Bool))
            case .integer:
                return .integer(
                    currentValue: defaultValue as! Int,
                    min: minimumValue as? Int,
                    max: maximumValue as? Int,
                    stepSize: stepSize as? Int
                )
            case .cgFloat:
                return .float(
                    currentValue: defaultValue as! CGFloat,
                    min: minimumValue as? CGFloat,
                    max: maximumValue as? CGFloat,
                    stepSize: stepSize as? CGFloat
                )
            case .double:
                return .double(
                    currentValue: defaultValue as! Double,
                    min: minimumValue as? Double,
                    max: maximumValue as? Double,
                    stepSize: stepSize as? Double
                )
            case .color:
                return .color(currentValue: defaultValue as! Color)
            case .string:
                return .string(currentValue: defaultValue as! String)
            case .stringList:
                return .stringList(
                    currentValue: defaultValue as! StringOption,
                    options: options!.map { $0 as! StringOption }
                )
            case .action:
                return .action(
                    currentValue: defaultValue as! ModelAction
                )
            }

        }
        set {
            switch newValue {
            case let .boolean(currentValue):
                self.defaultValue = currentValue as! T
            case let .integer(currentValue, _, _, _):
                self.defaultValue = currentValue as! T
            case let .float(currentValue, _, _, _):
                self.defaultValue = currentValue as! T
            case let .double(currentValue, _, _, _):
                self.defaultValue = currentValue as! T
            case let .color(currentValue):
                self.defaultValue = currentValue as! T
            case let .string(currentValue):
                self.defaultValue = currentValue as! T
            case let .stringList(currentValue, options):
                self.defaultValue = currentValue as! T
            case let .action(currentValue):
                self.defaultValue = currentValue as! T
            }
        }
    }
    
    public var dataType: DataType {
        return T.dataType
    }
}



