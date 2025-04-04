//
//  DevToolStore.swift
//  SETravel_Example
//
//  Created by Sam Chen on 2024/3/13.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

import Foundation
import Combine

public struct TimeEventItem<Value: Equatable>: Equatable {
    public let duration: TimeInterval
    public let value: Value

    public init(duration: TimeInterval, value: Value) {
        self.duration = duration
        self.value = value
    }
}

// TimerPublisher 定义
public class TimerPublisher<Value: Equatable>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never
    
    private let items: [TimeEventItem<Value>]
    private var subject = PassthroughSubject<Value, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(items: [TimeEventItem<Value>]) {
        self.items = items
    }
    
    // Publisher 的订阅方法
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Value == S.Input {
        subject.receive(subscriber: subscriber)
        startPublishing() // 开始发布事件
    }
    
    // 处理定时发布逻辑
    private func startPublishing() {
        var accumulatedTime: TimeInterval = 0
        
        for item in items {
            accumulatedTime = item.duration
            
            // 在每个延迟时间后发送事件
            DispatchQueue.main.asyncAfter(deadline: .now() + accumulatedTime) {
                self.subject.send(item.value)
                
                // 如果是最后一个事件，发送 .finished
                if item == self.items.last {
                    self.subject.send(completion: .finished)
                }
            }
        }
    }
}

public final class DevToolStore: ObservableObject {
    @Published var businesses: [String: DevToolBusiness] = [:]
    @Published var allBusinessesTitles: [String] = []
    private let storeName: String
    private let persistence: ModelPersistency
    private let allModels: Set<DevToolModel>
    public let timerPublisher: TimerPublisher<String>
    public let cancellable: AnyCancellable
    init(models: [ModelClusterType], storeName: String = "ZMDev") {
        
        
        let items = [
            TimeEventItem(duration: 1, value: "A"),
            TimeEventItem(duration: 1.5, value: "B"),
            TimeEventItem(duration: 5, value: "C")
        ]
        timerPublisher = TimerPublisher(items: items)
        timerPublisher.print()
        cancellable = timerPublisher.sink(
            receiveCompletion: { completion in
                print("Completed")
            },
            receiveValue: { value in
                print("Received value: \(value)")
            }
        )
        
        
        self.persistence = ModelPersistency(identifier: storeName)
        self.storeName = storeName
        self.allModels = Set(models.reduce([]) { $0 + $1.modelCluster})
        self.allModels.forEach { model in
            var business: DevToolBusiness
            if let existingBusiness = businesses[model.businessName] {
                business = existingBusiness
            } else {
                business = DevToolBusiness(title: model.businessName)
            }
            var module: DevToolModule
            if let existingModule = business.findModule(by: model.moduleName) {
                module = existingModule
            } else {
                module = DevToolModule(title: model.moduleName)
            }
            module.addModel(model)
            business.updateModule(module)
            businesses[model.businessName] = business
        }
        let sortedPair = businesses.sorted {$0.key < $1.key}
        self.allBusinessesTitles = sortedPair.map { $0.0 }
    }
    
    func updateModel(_ model: DevToolModel, withValue value: ModelDataValue) {
        guard var business = businesses[model.businessName] else { return }
        guard var module = business.findModule(by: model.moduleName) else { return }
        business.updateModule(module.updateModel(model))
        persistence.setValue(value, forModelIdentifiable: model)
    }
    
}



