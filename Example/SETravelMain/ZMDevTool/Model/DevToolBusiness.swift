//
//  DevToolBusiness.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

internal struct DevToolBusiness {
    let title: String
    var businesses: [String: TweakGroup] = [:]

    init(title: String) {
        self.title = title
    }
}
