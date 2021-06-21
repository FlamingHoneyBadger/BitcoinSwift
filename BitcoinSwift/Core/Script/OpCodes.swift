//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP

public protocol OpCodeProtocol {
    var name: String { get }
    var value: UInt8 { get }
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool
    func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool

}

struct  OP0 : OpCodeProtocol {
    
    public var name: String {"OP_0"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_0.rawValue}
    
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 0))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP0.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
    
}

struct  OP1 : OpCodeProtocol {
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP1.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
    
    public var name: String {"OP_1"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_1.rawValue}

     static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 1))
        return true
    }
}

struct  OP2 : OpCodeProtocol {
    
    
    public var name: String {"OP_2"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_2.rawValue}

    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 2))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP2.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}

struct  OP3 : OpCodeProtocol {
    
    
    public var name: String {"OP_3"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_3.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 3))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP3.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP4 : OpCodeProtocol {

    
    public var name: String {"OP_4"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_4.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 4))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP4.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP5 : OpCodeProtocol {
    
    
    public var name: String {"OP_5"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_5.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 5))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP5.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP6 : OpCodeProtocol {
    
    
    public var name: String {"OP_6"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_6.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 6))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP6.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP7 : OpCodeProtocol {
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP7.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
    
    public var name: String {"OP_7"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_7.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 7))
        return true
    }
}
struct  OP8 : OpCodeProtocol {
    
    public var name: String {"OP_8"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_8.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 8))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP8.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP9 : OpCodeProtocol {
    public var name: String {"OP_0"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_9.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 9))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP9.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP10 : OpCodeProtocol {
    public var name: String {"OP_10"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_10.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 10))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP10.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP11 : OpCodeProtocol {
    public var name: String {"OP_11"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_11.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 11))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP11.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP12 : OpCodeProtocol {
    public var name: String {"OP_12"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_12.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 12))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP12.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP13 : OpCodeProtocol {
    public var name: String {"OP_13"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_13.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 13))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP13.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP14 : OpCodeProtocol {
    public var name: String {"OP_14"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_14.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 14))
        return true
    }
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP14.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}
struct  OP15 : OpCodeProtocol {
    public var name: String {"OP_15"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_15.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 15))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP15.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}

struct  OP16 : OpCodeProtocol {
    public var name: String {"OP_16"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_16.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        stack.push(encodeNum(num: 16))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OP16.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}

struct  OPDUP : OpCodeProtocol {
    public var name: String {"OP_DUP"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_DUP.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        if(stack.isEmpty()){
            return false
        }
        
        guard let op = stack.peek() else {
            return false
        }
        
        stack.push(op)
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPDUP.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}

struct  OPHASH160 : OpCodeProtocol {
    public var name: String {"OP_HASH160"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_HASH160.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        if(stack.isEmpty()){
            return false
        }
        
        guard let element = stack.pop() else {
            return false
        }
        let h160 = Helper.hash160(data: element)
        stack.push(h160)
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPHASH160.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}


struct  OPEQUAL : OpCodeProtocol {
    public var name: String {"OP_EQUAL"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_EQUAL.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        if(stack.isEmpty()){
            return false
        }
        
        guard let element1 = stack.pop() else {
            return false
        }
        
        guard let element2 = stack.pop() else {
            return false
        }
        
        if(element1.elementsEqual(element2)){
            stack.push(encodeNum(num: 1))
        }else{
            stack.push(encodeNum(num: 0))
        }
        
        
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPEQUAL.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}

struct  OPVERIFY : OpCodeProtocol {
    public var name: String {"OP_VERIFY"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_VERIFY.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        if(stack.isEmpty()){
            return false
        }
        
        guard let element = stack.pop() else {
            return false
        }
        
        if(decodeNum(num: element.bytes) == 0){
            return false
        }
        
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPVERIFY.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}

struct  OPEQUALVERIFY : OpCodeProtocol {
    public var name: String {"OP_EQUALVERIFY"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_EQUALVERIFY.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        
        if(OPEQUAL.execute(&scriptStack, stack: &stack, altStack: &altStack, z: nil) &&
           OPVERIFY.execute(&scriptStack, stack: &stack, altStack: &altStack, z: nil) ){
            return true
        }
        
        return false
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPEQUALVERIFY.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}


struct  OPCHECKSIG : OpCodeProtocol {
    public var name: String {"OP_CHECKSIG"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_CHECKSIG.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        if(stack.isEmpty()){
            return false
        }

        guard let z = z else { return false }
        guard let pubKey = stack.pop() else { return false }
        guard let derSig = stack.pop() else { return false }
        
        
        let point =  secp256k1Point.parse(data: pubKey)
        
        let sig : ECDSASignature
        
        do {
            sig = try ECDSASignature.init(derSig)
        } catch  {
           print("OP_CHECKSIG failed to init signature")
           return false
        }
        
        if(point.verify(z: z, sig: sig)){
            stack.push(encodeNum(num: 1))
        }else{
            stack.push(encodeNum(num: 0))
        }
        
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPCHECKSIG.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}


struct  OPCHECKMULTISIG : OpCodeProtocol {
    public var name: String {"OP_CHECKMULTISIG"}
    public var value: UInt8 {OP_CODE_FUNCTIONS.OP_CHECKMULTISIG.rawValue}
    static func execute(_ scriptStack: inout Script, stack: inout Script , altStack: inout Script, z : GMPInteger? ) -> Bool {
        if(stack.isEmpty()){
            return false
        }

        guard let z = z else { return false }
        guard let nBytes = stack.pop() else { return false }
        var n = decodeNum(num: nBytes.bytes)
        
        if(stack.storage.count  < n + 1){
           return false
        }
        
        var SecPubKeys : [Data] = []
        
        while (n > 0) {
            guard let pubkey = stack.pop() else { return false }
            SecPubKeys.append(pubkey)
            n -= 1
        }
        guard let mBytes = stack.pop() else { return false }
        var m = decodeNum(num: mBytes.bytes)

        if(stack.storage.count < m + 1){
            return false
        }
        
        var sigBytes : [Data] = []
        
        while m > 0 {
            guard let sig = stack.pop() else { return false }
            sigBytes.append(sig)
            m-=1
        }
        //pop value for OP_CHECKMULTISIG bug
        _ = stack.pop()
        var pubKeyPoints :[secp256k1Point] = []
        
        for item in SecPubKeys {
            pubKeyPoints.append(secp256k1Point.parse(data: item))
        }
        
        var sigs : [ECDSASignature] = []
        
        for item in sigBytes {
            
            do {
                var i = item
                print(i.hexEncodedString())
                sigs.append(try ECDSASignature.init(i))
            } catch  {
               print("OP_CHECKMULTISIG failed to init signature")
               return false
            }
            
        }
        
        
        for sig in sigs{
            
            if(pubKeyPoints.count == 0 ){
                print("signatures no good or not in right order")
                return false
            }
            
            while !pubKeyPoints.isEmpty {
                let point = pubKeyPoints.removeFirst()
                if(point.verify(z: z, sig: sig)){
                    break
                }
            }
            
        }

        stack.push(encodeNum(num: 1))
        return true
    }
    
    func execute(_ scriptStack: inout Script, stack: inout Script, altStack: inout Script, z: GMPInteger?) -> Bool {
        OPCHECKMULTISIG.execute(&scriptStack, stack: &stack, altStack: &altStack, z: z)
    }
}



func encodeNum(num: Int) -> Data{
    if (num == 0) { return Data([0x00]) }

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
