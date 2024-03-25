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

    init(identifier: String, appGroup: String?) {
        self.diskPersistency = ModelDiskPersistency(identifier: identifier, appGroup: appGroup)
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
    private let fileURL: URL
    private let fileManager = FileManager.default
    private static func fileURLForIdentifier(_ identifier: String, appGroup: String?) -> URL {
        guard let appGroupName = appGroup else {
            return try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("SwiftTweaks")
                .appendingPathComponent("\(identifier)")
                .appendingPathExtension("db")
        }
        return FileManager().containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!
            .appendingPathComponent("SwiftTweaks")
            .appendingPathComponent("\(identifier)")
            .appendingPathExtension("db")
    }

    private let queue = DispatchQueue(label: "org.khanacademy.swift_tweaks.disk_persistency", attributes: [])

    private static let dataClassName = "TweakDiskPersistency.Data"

    init(identifier: String, appGroup: String?) {
        NSKeyedUnarchiver.setClass(TweakDiskPersistency.Data.self, forClassName: TweakDiskPersistency.dataClassName)
        NSKeyedArchiver.setClassName(TweakDiskPersistency.dataClassName, for: TweakDiskPersistency.Data.self)

        self.fileURL = ModelDiskPersistency.fileURLForIdentifier(identifier, appGroup: appGroup)
        self.ensureDirectoryExists()
    }

    /// Creates a directory (if needed) for our persisted TweakCache on disk
    private func ensureDirectoryExists() {
        self.queue.async {
            try! FileManager.default.createDirectory(at: self.fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        }
    }

    func loadFromDisk() -> ModelCache {
        var result: ModelCache!

        self.queue.sync {
            result = (try? Foundation.Data(contentsOf: self.fileURL))
                .flatMap {
                    let result = NSKeyedUnarchiver.unarchiveObject(with: $0) as? TweakDiskPersistency.Data
                    return result?.cache
                }
                ?? [:]
        }

        return result
    }

    func saveToDisk(_ data: ModelCache) {
        self.queue.async {
            let nsData = NSKeyedArchiver.archivedData(withRootObject: Data(cache: data))
            try! nsData.write(to: self.fileURL, options: [.atomic])
        }
    }

    @objc(_TtCC11SwiftTweaksP33_9992646B9FE5A082B6B2A55DA4E653F420TweakDiskPersistency4Data) private final class Data: NSObject, NSCoding {
        let cache: ModelCache

        init(cache: ModelCache) {
            self.cache = cache
        }

        @objc convenience init?(coder aDecoder: NSCoder) {
            var cache: ModelCache = [:]

            // Read through each TweakViewDataType...
            for dataType in TweakViewDataType.allCases {
                // If a sub-dictionary exists for that type,
                if let dataTypeDictionary = aDecoder.decodeObject(forKey: dataType.nsCodingKey) as? Dictionary<String, AnyObject> {
                    // Read through each entry and populate the cache
                    for (key, value) in dataTypeDictionary {
                        if let value = Data.tweakableTypeWithAnyObject(value, withType: dataType) {
                            cache[key] = value
                        }
                    }
                }
            }

            self.init(cache: cache)
        }

        @objc fileprivate func encode(with aCoder: NSCoder) {

            // Our "dictionary of dictionaries" that is persisted on disk
            var diskPersistedDictionary: [TweakViewDataType : [String: AnyObject]] = [:]

            // For each thing in our TweakCache,
            for (key, value) in cache {
                let dataType = type(of: value).tweakViewDataType

                // ... create the "sub-dictionary" if it doesn't already exist for a particular TweakViewDataType
                if diskPersistedDictionary[dataType] == nil {
                    diskPersistedDictionary[dataType] = [:]
                }

                // ... and set the cached value inside the sub-dictionary.
                diskPersistedDictionary[dataType]![key] = value.nsCoding
            }

            // Now we persist the "dictionary of dictionaries" on disk!
            for (key, value) in diskPersistedDictionary {
                aCoder.encode(value, forKey: key.nsCodingKey)
            }
        }

        // Reads from the cache, casting to the appropriate TweakViewDataType
        private static func tweakableTypeWithAnyObject(_ anyObject: AnyObject, withType type: TweakViewDataType) -> TweakableType? {
            switch type {
            case .integer: return anyObject as? Int
            case .boolean: return anyObject as? Bool
            case .cgFloat: return anyObject as? CGFloat
            case .double: return anyObject as? Double
            case .uiColor: return anyObject as? UIColor
            case .string: return anyObject as? String
            case .stringList:
                guard let stringOptionString = anyObject as? String else {
                    return nil
                }
                return StringOption(value: stringOptionString)
            case .action: return nil
            }
        }
    }
}

private extension DataType {
    var nsCodingKey: String {
        switch self {
        case .boolean: return "boolean"
        case .integer: return "integer"
        case .cgFloat: return "cgfloat"
        case .double: return "double"
        case .color: return "color"
        case .string: return "string"
        case .stringList: return "stringlist"
        case .action: return "action"
        }
    }
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

