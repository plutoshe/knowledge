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
    func relocateHead()
}

public class Node<T> {
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(value: T) {
        self.value = value
    }
}

public class Queue<T>: ReviewOrderProtocol {
    fileprivate var head: Node<T>?
    private var tail: Node<T>?
    public var count: Int = 0

    public func isEmpty() -> Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public var last: Node<T>? {
        return tail
    }
    
    public func append(value: T) {
        let newNode = Node<T>(value: value);
        if let tailNode = self.tail {
            tailNode.next = newNode
            newNode.previous = tailNode
            self.tail = newNode
        } else {
            self.head = newNode
            self.tail = newNode
        }
        count += 1
    }
    
    public func removeAll() {
        self.head = nil
        self.tail = nil
        count = 0
    }
    
    public func removeHead() {
        if let head = self.head {
            if let next = head.next {
                next.previous = nil
                self.head = next;
            } else {
                self.head = nil
                self.tail = nil
            }
            count -= 1
        }
    }
    
    public func peek() -> T? {
        return self.first?.value
    }
    
    public func relocateHead() {
        self.append(value: head!.value)
        self.removeHead()
    }
    
}

public class QueueBasedOnArray<T>: ReviewOrderProtocol {
    public var count: Int {
        get {
            return self.elementArray.count
        }
    }
    var relocationFrom: Int = 7
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
    
    public func relocateHead() {
        if self.elementArray.count > 0 {
            var pos = Int(arc4random_uniform(UInt32(scope))) + relocationFrom
            if pos > self.elementArray.count {
                pos = self.elementArray.count
            }
            self.elementArray.insert(elementArray[0], at: pos)
            self.elementArray.remove(at: 0)
        }
    }
}
