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

extension BaseType {
    public func hash(into hasher: inout Hasher) {
            hasher.combine(Self.dataType)
        }
        
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (Self.dataType == Self.dataType)
    }
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

public enum ModelDataValue {
    case boolean(currentValue: Bool)
    case integer(currentValue: Int, min: Int?, max: Int?, stepSize: Int?)
    case float(currentValue: CGFloat, min: CGFloat?, max: CGFloat?, stepSize: CGFloat?)
    case double(currentValue: Double, min: Double?, max: Double?, stepSize: Double?)
    case color(currentValue: Color)
    case string(currentValue: String)
    case stringList(currentValue: StringOption, options: [StringOption])
    case action(currentValue: ModelAction)
}

extension ModelDataValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .boolean(let currentValue):
            hasher.combine(currentValue)
        case .integer(let currentValue, _, _, _):
            hasher.combine(currentValue)
        case .float(let currentValue, _, _, _):
            hasher.combine(currentValue)
        case .double(let currentValue, _, _, _):
            hasher.combine(currentValue)
        case .color(let currentValue):
            hasher.combine(currentValue)
        case .string(let currentValue):
            hasher.combine(currentValue)
        case .stringList(let currentValue, _):
            hasher.combine(currentValue)
        case .action(let currentValue):
            hasher.combine(currentValue)
        }
    }
}

public struct StringOption {
    public let value: String
    public init(value: String) {
        self.value = value
    }
}

extension StringOption: Hashable {
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

extension Color: BaseType {
    public static var dataType: DataType {
        return .color
    }
}

extension String: BaseType {
    public static var dataType: DataType {
        return .string
    }
}

extension ModelDataValue {
    var codingKey: String {
        switch self {
        case .boolean: return "boolean"
        case .integer: return "integer"
        case .float: return "cgfloat"
        case .double: return "double"
        case .color: return "color"
        case .string: return "string"
        case .stringList: return "stringlist"
        case .action: return "action"
        }
    }
}

