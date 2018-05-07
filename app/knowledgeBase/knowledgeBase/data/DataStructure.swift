//
//  DataStructure.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/18.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Foundation


protocol ReviewOrderProtocol {
    associatedtype Element
    func isEmpty() -> Bool
    var count: Int {
        get
    }
    func append(value: Element)
    func removeHead()
    func removeAll()
    func peek() -> Element?
    func relocateHeadByScope()
    func relocateHeadToTail()
}

public class Node<T> {
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(value: T) {
        self.value = value
    }
}

public class QueueBasedOnArray<T>: ReviewOrderProtocol {
    public var count: Int {
        get {
            return self.elementArray.count
        }
    }
    var relocationFrom: Int = 10
    var relocationTo: Int = 20
    var scope = 0
    init() {
        scope = relocationTo - relocationFrom + 1
    }
    init(relocationFrom: Int, relocationTo: Int) {
        self.relocationFrom = relocationFrom
        self.relocationTo = relocationTo
        self.scope = relocationTo - relocationFrom + 1
    }
    
    private var elementArray = [T]()
    public func isEmpty() -> Bool {
        return elementArray.count == 0
    }
    
    
    public func append(value: T) {
        elementArray.append(value)
    }
    
    public func removeAll() {
        self.elementArray.removeAll()
    }
    
    public func removeHead() {
        self.elementArray.remove(at: 0)
    }
    
    public func peek() -> T? {
        if self.elementArray.count > 0 {
            return self.elementArray[0]
        } else {
            return nil
        }
    }
    
    public func relocateHeadByScope() {
        if self.elementArray.count > 0 {
            var pos = Int(arc4random_uniform(UInt32(scope))) + relocationFrom
            if pos > self.elementArray.count {
                pos = self.elementArray.count
            }
            self.elementArray.insert(elementArray[0], at: pos)
            self.elementArray.remove(at: 0)
        }
    }
    
    public func relocateHeadToTail() {
        self.elementArray.append(elementArray[0])
        self.elementArray.remove(at: 0)
    }
}
