//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation


public protocol OpCodeProtocol {
    var name: String { get }
    var value: UInt8 { get }
    static func execute(_ scriptStack: inout Script<Data>) -> Bool
}

struct  OP_0 : OpCodeProtocol {
    public var name: String {"OP_0"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_0.rawValue}

    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 0))
        return true
    }
}

struct  OP_1 : OpCodeProtocol {
    public var name: String {"OP_1"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_1.rawValue}

    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 1))
        return true
    }
}

struct  OP_2 : OpCodeProtocol {
    public var name: String {"OP_2"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_2.rawValue}

    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 2))
        return true
    }
}

struct  OP_3 : OpCodeProtocol {
    public var name: String {"OP_3"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_3.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 3))
        return true
    }
}
struct  OP_4 : OpCodeProtocol {
    public var name: String {"OP_4"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_4.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 4))
        return true
    }
}
struct  OP_5 : OpCodeProtocol {
    public var name: String {"OP_5"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_5.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 5))
        return true
    }
}
struct  OP_6 : OpCodeProtocol {
    public var name: String {"OP_6"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_6.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 6))
        return true
    }
}
struct  OP_7 : OpCodeProtocol {
    public var name: String {"OP_7"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_7.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 7))
        return true
    }
}
struct  OP_8 : OpCodeProtocol {
    public var name: String {"OP_8"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_8.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 8))
        return true
    }
}
struct  OP_9 : OpCodeProtocol {
    public var name: String {"OP_0"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_9.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 9))
        return true
    }
}
struct  OP_10 : OpCodeProtocol {
    public var name: String {"OP_10"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_10.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 10))
        return true
    }
}
struct  OP_11 : OpCodeProtocol {
    public var name: String {"OP_11"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_11.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 11))
        return true
    }
}
struct  OP_12 : OpCodeProtocol {
    public var name: String {"OP_12"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_12.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 12))
        return true
    }
}
struct  OP_13 : OpCodeProtocol {
    public var name: String {"OP_13"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_13.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 13))
        return true
    }
}
struct  OP_14 : OpCodeProtocol {
    public var name: String {"OP_14"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_14.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 14))
        return true
    }
}
struct  OP_15 : OpCodeProtocol {
    public var name: String {"OP_15"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_15.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 15))
        return true
    }
}

struct  OP_16 : OpCodeProtocol {
    public var name: String {"OP_16"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_16.rawValue}
    static func execute(_ scriptStack: inout Script<Data>) -> Bool {
        scriptStack.push(encodeNum(num: 16))
        return true
    }
}



func encodeNum(num: Int) -> Data{
    if (num == 0) { return Data() }

    var abs = abs(num)
    let negative = num < 0
    var result : Data = Data()
    while (abs != 0 ) {
            result.append(UInt8(abs & 0xff))
            abs >>= 8
    }

    if ((result.last! & 80) != 0){
        if(negative){ result.append(0x80) }
        else{ result.append(0) }
    }else if(negative){ result[result.count-1] |= 0x80 }

    return result
}

func decodeNum(num: [UInt8]) -> Int{

    if(num == []){ return 0 }

    let BigE : [UInt8] = num.reversed()
    var result : Int
    var negative = false
    if ((BigE[0] & 0x80) != 0){
        negative = true
        result = Int((BigE[0] & 0x7f))
    }else{ result = Int(BigE[0]) }

    for item in BigE[1..<BigE.count] {
        result <<= 8
        result += Int(item)
    }

    if(negative){ return -result }
    else { return result }
}