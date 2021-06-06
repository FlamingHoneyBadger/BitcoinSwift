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

    enum ScriptError : Error {
        case ParseError
        case ValueTooLong
    }

}
