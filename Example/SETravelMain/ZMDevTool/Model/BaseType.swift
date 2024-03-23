//
//  DevToolType.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

public protocol BaseType {
    static var dataType: DataType { get }
}

public enum DataType: CaseIterable {
    case boolean
    case integer
    case cgFloat
    case double
    case color
    case string
    case stringList
    case action
}

public enum ModelDefaultData {
    case boolean(defaultValue: Bool)
    case integer(defaultValue: Int, min: Int?, max: Int?, stepSize: Int?)
    case float(defaultValue: CGFloat, min: CGFloat?, max: CGFloat?, stepSize: CGFloat?)
    case doubleTweak(defaultValue: Double, min: Double?, max: Double?, stepSize: Double?)
    case color(defaultValue: UIColor)
    case string(defaultValue: String)
    case stringList(defaultValue: StringOption, options: [StringOption])
    case action(defaultValue: ModelAction)
}

public struct StringOption {
    public let value: String
    public init(value: String) {
        self.value = value
    }
}

extension StringOption: Equatable {
    public static func ==(lhs: StringOption, rhs: StringOption) -> Bool {
        return lhs.value == rhs.value
    }
}

extension StringOption: BaseType {
    public static var dataType: DataType {
        return .stringList
    }
}

extension Bool: BaseType {
    public static var dataType: DataType {
        return .boolean
    }
}

extension Int: BaseType {
    public static var dataType: DataType {
        return .integer
    }
}

extension CGFloat: BaseType {
    public static var dataType: DataType {
        return .cgFloat
    }
}

extension Double: BaseType {
    public static var dataType: DataType {
        return .double
    }
}

extension UIColor: BaseType {
    public static var dataType: DataType {
        return .color
    }
}

extension String: BaseType {
    public static var dataType: DataType {
        return .string
    }
}

