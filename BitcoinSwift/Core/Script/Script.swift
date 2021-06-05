//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation

public protocol Stack {
    associatedtype OpCode
    func peek() -> OpCode?
    mutating func push(_ opcode: OpCode)
    @discardableResult mutating func pop() -> OpCode?
    func isEmpty() -> Bool
}


public struct Script<Data>: Stack {
    public func isEmpty() -> Bool { peek() == nil }

    var storage = [Data]()

    public func peek() -> Data? { storage.last }

    mutating public func push(_ opcode: Data) { storage.append(opcode) }

    mutating public func pop() -> Data? { storage.popLast() }



}