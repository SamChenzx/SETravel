//
//  ModelPersistency.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/22.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import SwiftUI

internal typealias ModelCache = [String: BaseType]

protocol ModelIdentifiable {
    var persistenceIdentifier: String { get }
}

internal final class ModelPersistency {
    private let diskPersistency: ModelDiskPersistency

    private var modelCache: ModelCache = [:]

    init(identifier: String) {
        self.diskPersistency = ModelDiskPersistency(identifier: identifier)
        self.modelCache = self.diskPersistency.loadFromDisk()
    }

    internal func currentValueForModel<T>(_ model: DevToolModel<T>) -> T? {
        return persistedValueForModelIdentifiable(AnyDevToolModel(model: model)) as? T
    }

    internal func currentValueForModel<T>(_ model: DevToolModel<T>) -> T? where T: Comparable {
        if let currentValue = persistedValueForModelIdentifiable(AnyDevToolModel(model: model)) as? T {
                return clip(currentValue, model.minimumValue, model.maximumValue)
        }
        return nil
    }

    internal func persistedValueForModelIdentifiable(_ modelID: ModelIdentifiable) -> BaseType? {
        return modelCache[modelID.persistenceIdentifier]
    }

    internal func setValue(_ value: BaseType?,  forModelIdentifiable modelID: ModelIdentifiable) {
        modelCache[modelID.persistenceIdentifier] = value
        self.diskPersistency.saveToDisk(modelCache)
    }

    internal func clearAllData() {
        modelCache = [:]
        self.diskPersistency.saveToDisk(modelCache)
    }
}

private final class ModelDiskPersistency {
    private let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("ZMDevTool").appendingPathExtension("json")
    init(identifier: String) {
        self.ensureDirectoryExists()
    }

    private func ensureDirectoryExists() {
        try! FileManager.default.createDirectory(at: self.fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
    }

    func loadFromDisk() -> ModelCache {
        var result: ModelCache!
        guard let jsonData = FileManager.default.contents(atPath: self.fileURL.path) else {
            print("Failed to read JSON file from path: \( self.fileURL.path)")
            return [:]
        }
        do {
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? ModelCache else {
                print("Failed to parse JSON file into a dictionary.")
                return [:]
            }
            result = jsonDictionary
        } catch {
            print("Error parsing JSON file: \(error)")
        }
        return result
    }

    func saveToDisk(_ data: ModelCache) {
        do {
            let jsondata = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            try jsondata.write(to: self.fileURL)
        } catch {
            print(error)
        }
    }
}
