//
//  DevToolModel.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

public struct DevToolModel<T: BaseType> {
    public let businessName: String
    public let moduleName: String
    public let featureName: String
    internal let defaultValue: T
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

extension DevToolModel: ModelType {
    public var model: ModelType {
        return self
    }

    public var defaultData: ModelDefaultData {
        switch T.dataType {
        case .boolean:
            return .boolean(defaultValue: (defaultValue as! Bool))
        case .integer:
            return .integer(
                defaultValue: defaultValue as! Int,
                min: minimumValue as? Int,
                max: maximumValue as? Int,
                stepSize: stepSize as? Int
            )
        case .cgFloat:
            return .float(
                defaultValue: defaultValue as! CGFloat,
                min: minimumValue as? CGFloat,
                max: maximumValue as? CGFloat,
                stepSize: stepSize as? CGFloat
            )
        case .double:
            return .doubleTweak(
                defaultValue: defaultValue as! Double,
                min: minimumValue as? Double,
                max: maximumValue as? Double,
                stepSize: stepSize as? Double
            )
        case .color:
            return .color(defaultValue: defaultValue as! Color)
        case .string:
            return .string(defaultValue: defaultValue as! String)
        case .stringList:
            return .stringList(
                defaultValue: defaultValue as! StringOption,
                options: options!.map { $0 as! StringOption }
            )
        case .action:
            return .action(
                defaultValue: defaultValue as! ModelAction
            )
        }
    }

    public var dataType: DataType {
        return T.dataType
    }
}

extension DevToolModel: Hashable, Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(modelIdentifier)
    }
    
    public static func == (lhs: DevToolModel<T>, rhs: DevToolModel<T>) -> Bool {
        return lhs.modelIdentifier == rhs.modelIdentifier
    }
}

extension DevToolModel: ModelIdentifiable {
    var persistenceIdentifier: String {
        return modelIdentifier
    }
}

extension DevToolModel: ModelClusterType {
    public var modelCluster: [AnyDevToolModel] {
        return [AnyDevToolModel.init(model: self)]
    }
}



