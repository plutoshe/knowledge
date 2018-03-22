//
//  DataStructure.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/18.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Foundation

public class Node<T> {
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(value: T) {
        self.value = value
    }
}

public struct Queue<T> {
    fileprivate var head: Node<T>?
    private var tail: Node<T>?

    public func isEmpty() -> Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public var last: Node<T>? {
        return tail
    }
    
    public mutating func append(value: T) {
        let newNode = Node<T>(value: value);
        if let tailNode = self.tail {
            tailNode.next = newNode
            newNode.previous = tailNode
            self.tail = newNode
        } else {
            self.head = newNode
            self.tail = newNode
        }
    }
    
    public mutating func removeAll() {
        self.head = nil
        self.tail = nil
    }
    
    public mutating func remove() {
        if let head = self.head {
            if let next = head.next {
                next.previous = nil
                self.head = next;
            } else {
                self.head = nil
                self.tail = nil
            }
        }
    }
    
    public func peek() -> T? {
        return self.first?.value
    }
}

