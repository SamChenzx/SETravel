//
//  Clip.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/23.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

internal func clip<U: Comparable>(_ value: U, _ minimum: U?, _ maximum: U?) -> U {
    var result = value

    if let minimum = minimum {
        result = max(minimum, result)
    }

    if let maximum = maximum {
        result = min(maximum, result)
    }
    return result
}

func printAddress(_ object: UnsafeRawPointer) -> String {
    let addr = Int(bitPattern: object)
    let str = String(format: "%p", addr)
    return str
}
