//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP

public protocol Stack {
    func peek() -> Data?
    mutating func push(_ opcode: Data)
    @discardableResult mutating func pop() -> Data?
    func isEmpty() -> Bool
}


public struct Script: Stack {
    public func isEmpty() -> Bool { peek() == nil }

    var storage = [Data]()

    public func peek() -> Data? { storage.last }

    mutating public func push(_ opcode: Data) { storage.append(opcode) }

    mutating public func pop() -> Data? { storage.popLast() }


    public  var description: String {
        var result :[String]  = []
        for item in storage {
            if (item.count == 1){
                let opRaw = item.bytes[0]
                do {
                    let op = try OP_CODE_FUNCTIONS.init(rawValue:opRaw)?.OpFunction()
                    result.append(op?.name ?? "OP_\(opRaw)")
                } catch {
                    result.append("OP_\(opRaw)")
                }
            }else{
                result.append(item.hexEncodedString())
            }
        }
        return result.joined(separator: " ")
    }

    public func RawSerialize() throws -> Data {
        var result = Data()

        for item in storage {
            if (item.count == 1){
               result.append(item)
            }else{
               let length =  item.count
                if(length < 75){
                    result.append(UInt8(length))
                }else if(length > 75 && length < 0x100){
                    result.append(UInt8(76))
                    result.append(Data(withUnsafeBytes(of: length.littleEndian, Array.init)))
                }else if(length >= 0x100 && length <= 520){
                    result.append(UInt8(76))
                    result.append(Data(withUnsafeBytes(of: length.littleEndian, Array.init)))
                }else{
                    throw ScriptError.ValueTooLong
                }
                result.append(item)
            }
        }
        return result
    }

    public func Serialize() throws -> Data {
        let data = try RawSerialize()
        // result = varInt(length) + RawSerialize
        var result  = try Helper.encodeVarInt(UInt64(data.bytes.count))
        result.append(data)
        return result
    }
    
    public func evaluate(z: GMPInteger, witness: Script? = nil ) throws -> Bool {
        // get copy of stack to evaluate in case a specialscript a case
        var copy = self
        var stack: Script = Script()
        var altstack: Script = Script()
        
        for item in copy.storage {
            let command = item
            
            // command is OP
            if( command.count == 1){
                let op = OP_CODE_FUNCTIONS.init(rawValue: (command.bytes[0]))
                
                
                switch op!.rawValue {
                case 99...100:
                    break
                   // op_if/op_notif require the script to test values
                   // TODO: implement ops
                case 107...108:
                    break
                   // op_toaltstack/op_fromaltstack require the altstack
                   // TODO: implement ops
                case 172...175:
                   // op_toaltstack/op_fromaltstack require the altstack
                   // TODO: implement ops
                    if (!(try op!.OpFunction().execute(&copy,stack: &stack,altStack: &altstack,z: z))){
                        return false
                    }
                default:
                    if(!( try op!.OpFunction().execute(&copy,stack:  &stack,altStack: &altstack,z: nil))){
                        return false
                    }
                }
                
            }else{
                stack.push(command)
                
                if (copy.isP2SHScriptPubkey()){
                    
                }
                
                if(stack.isP2WPKHScriptPubkey()){
                    // add command to stack
                    stack.storage.append(command)
                    // OP_HASH160
                    let op1 = OP_CODE_FUNCTIONS.init(rawValue: copy.pop()!.bytes[0])
                    
                    let h160 = copy.pop()
                    // OP_EQUAL
                    let op2 = OP_CODE_FUNCTIONS.init(rawValue: copy.pop()!.bytes[0])

                    if(!(try op1!.OpFunction().execute(&copy, stack: &stack, altStack: &altstack, z: nil))){
                        return false
                    }
                    stack.push(h160!)
                    if(!(try op2!.OpFunction().execute(&copy, stack: &stack, altStack: &altstack, z: nil))){
                        return false
                    }
                    
                    let opVerify = OP_CODE_FUNCTIONS.init(rawValue: OP_CODE_FUNCTIONS.OP_VERIFY.rawValue)
                    
                    if(!(try opVerify!.OpFunction().execute(&copy, stack: &stack, altStack: &altstack, z: nil))){
                        return false
                    }
                    
                    // if hashs match then add RedeemScript
                    var data = try Helper.encodeVarInt(UInt64(command.count))
                    data.append(command)
                    let redeemScript = try Script(InputStream(data: data))
                    
                    copy.storage.append(contentsOf: redeemScript.storage)
                }
            }
            
        }// end of while
        
        if(stack.storage.count == 0){
            return false
        }else if(stack.pop()!.isEmpty){
            return false
        }
        
        return true
        
    }

    public init()  {
    }
    
    public init (_ data: Data) throws {
        let input = InputStream(data: data)
        input.open()
        defer {
            input.close()
        }
        try self.init(input)
    }

        public init(_ data: InputStream) throws {
        let length = try Helper.readVarInt(data)
        var count = 0
        while count < length {
            // read one byte
            let current = try data.readData(maxLength: 1)
            // increment count by 1
            count += 1
            let current_byte = current.bytes[0]
            // if the current byte is between 1 and 75 inclusive
            // we read the data to put on the stack
            if(current_byte >= 1 && current_byte <= 75 ){
                let n = Int(current_byte)
                // push the data on stack
                self.push(try data.readData(maxLength: n))
                // increment count
                count += n
            }else if (current_byte == OP_CODE_FUNCTIONS.OP_PUSHDATA1.rawValue){
                let dataLength =  Int(try data.readData(maxLength: 1).littleEndianUInt64())
                self.push(try data.readData(maxLength: dataLength))
                count += dataLength + 1
            }else if (current_byte == OP_CODE_FUNCTIONS.OP_PUSHDATA2.rawValue){
                //
                let dataLength =  Int(try data.readData(maxLength: 2).littleEndianUInt64())
                self.push(try data.readData(maxLength: dataLength))
                count += dataLength + 2
            }else{
                 // push single byte op code
                 push(Data([current_byte]))
            }
        }
        if (count != length){
            throw ScriptError.ParseError
        }
    }
    
    
    func isP2SHScriptPubkey() -> Bool {
        if(storage.count == 3){
         return     ((storage[0].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_HASH160.rawValue)
                    && (storage[1].count == 20)
                    && (storage[2].count == 1 && storage[2].bytes[0] == OP_CODE_FUNCTIONS.OP_EQUAL.rawValue))
        }
        return false
    }
    
    func isP2PKHScriptPubkey() -> Bool {
        if(storage.count == 5){
         return
                    ((storage[0].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_DUP.rawValue)
                    && (storage[1].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_HASH160.rawValue)
                    && (storage[2].count == 20)
                    && (storage[3].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_EQUALVERIFY.rawValue)
                    && (storage[4].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_CHECKSIG.rawValue))
        }
        
        return false
    }
    
    
    func isP2WSHScriptPubkey() -> Bool {
        if(storage.count == 2){
         return  ( (storage[0].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_0.rawValue)
                    && (storage[1].count == 32))
        }
        return false
    }

    func isP2WPKHScriptPubkey() -> Bool {
        if(storage.count == 2){
         return   ((storage[0].count == 1 && storage[0].bytes[0] == OP_CODE_FUNCTIONS.OP_0.rawValue)
                    && (storage[1].count == 20))
        }
        return false
    }
    
    enum ScriptError : Error {
        case ParseError
        case ValueTooLong
        case OpCodeExecuteFailed(opcode:OpCodeProtocol)
    }

}
