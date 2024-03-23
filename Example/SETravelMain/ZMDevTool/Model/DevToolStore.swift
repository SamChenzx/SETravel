//
//  DevToolStore.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public final class DevToolStore {
    var devToolCollections: [String: DevToolBusiness] = [:]
    private let storeName: String = ""
    init(devToolCollections: [String : DevToolBusiness]) {
        self.devToolCollections = devToolCollections
    }
}
