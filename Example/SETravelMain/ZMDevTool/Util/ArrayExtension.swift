//
//  ArrayExtension.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/4/11.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    mutating func appendAndSort(_ newElement: Element) {
        append(newElement)
        sort()
    }
}
