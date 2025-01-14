//
//  Types.swift
//  Osiris
//
//  Created by Hadi Ahmad on 1/13/25.
//

public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

public struct QueueArray<T>: Queue, Sequence {
    private var array: [T] = []
    
    public init() {}
    
    public var isEmpty: Bool {
        array.isEmpty
    }

    public var peek: T? {
        array.first
    }
    
    public mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }

    public mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
    
    // so i can loop through it
    public func makeIterator() -> Array<T>.Iterator {
        return array.makeIterator()
    }
}

