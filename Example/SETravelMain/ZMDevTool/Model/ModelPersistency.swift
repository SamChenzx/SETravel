//
//  ModelPersistency.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/22.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

internal typealias TweakCache = [String: BaseType]

protocol ModelIdentifiable {
    var persistenceIdentifier: String { get }
}

private extension BaseType {
    /// Gets the underlying value from a BaseType
    var nsCoding: AnyObject {
        switch type(of: self).dataType {
        case .boolean: return self as! Bool as AnyObject
        case .integer: return self as! Int as AnyObject
        case .cgFloat: return self as! CGFloat as AnyObject
        case .double: return self as! Double as AnyObject
        case .color: return self as! Color as AnyObject
        case .string: return self as! NSString
        case .stringList: return (self as! StringOption).value as AnyObject
        case .action: return true as AnyObject
        }
    }
}

