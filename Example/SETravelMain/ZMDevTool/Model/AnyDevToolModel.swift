//
//  AnyDevToolModel.swift
//  SETravel_Example
//
//  Created by Sam on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public struct AnyDevToolModel: TweakType {
    public let model: TweakType

    public var collectionName: String { return model.collectionName }
    public var groupName: String { return model.groupName }
    public var tweakName: String { return model.tweakName }

    public var tweakDefaultData: TweakDefaultData { return tweak.tweakDefaultData }

    public init(tweak: TweakType) {
        self.model = tweak.model
    }
}

public protocol TweakType: TweakClusterType {
    var model: TweakType { get }

    var collectionName: String { get }
    var groupName: String { get }
    var tweakName: String { get }

    var tweakDefaultData: TweakDefaultData { get }
}
