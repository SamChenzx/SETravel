//
//  DevToolModel.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public struct DevToolModel<T: BaseType> {
    let businessName: String
    let moduleName: String
    let featureName: String
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
