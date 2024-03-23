//
//  DevToolModelAction.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/15.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation

public typealias ModelActionClosure = () -> Void

public class ModelAction {
    public enum Error: Swift.Error {
        case wrongIdentifier
    }
    
    public typealias ClosureIdentifier = UInt
    
    private var lastToken: ClosureIdentifier = 0
    private var closures: [ClosureIdentifier: ModelActionClosure] = [:]
    
    public init() {}
    
    public func addClosure(_ closure: @escaping ModelActionClosure) -> ClosureIdentifier {
        let nextToken = lastToken + 1
        closures[nextToken] = closure
        lastToken = nextToken
        return nextToken
    }
    
    public func removeClosure(withIdentifier identifier: ClosureIdentifier) throws {
        guard closures.keys.contains(identifier) else {
            throw Error.wrongIdentifier
        }
        closures[identifier] = nil
    }
        
    func executeAllClosures() {
        closures.keys.sorted().forEach { closures[$0]?() }
    }
}

extension ModelAction: BaseType {
    public static var dataType: DataType {
        return .action
    }
}

extension DevToolModel where T == ModelAction {
    public init(_ businessName: String, _ moduleName: String, _ featureName: String) {
        self.init(businessName, moduleName, featureName, ModelAction())
    }
    
    @discardableResult
    public func addClosure(_ closure: @escaping ModelActionClosure) -> ModelAction.ClosureIdentifier {
        return defaultValue.addClosure(closure)
    }
    
    public func removeClosure(with identifier: ModelAction.ClosureIdentifier) throws {
        try defaultValue.removeClosure(withIdentifier: identifier)
    }
}
