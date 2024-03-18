//
//  DevToolType.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public protocol DevToolType {
    static var dataType: DevToolDataType { get }
}

public enum DevToolDataType {
    case boolean
    case integer
    case float
    case double
    case color
    case string
    case stringList
    case action
    
    public static let allTypes: [DevToolDataType] = [
        .boolean, .integer, .float, .double, .color, .string, .stringList, .action
    ]
}
