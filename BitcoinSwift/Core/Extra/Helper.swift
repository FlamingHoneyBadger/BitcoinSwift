//
// Created by FlamingHoneyBadger on 5/16/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP
import CommonCrypto
import CryptoKit

 class Helper {

    static func hash160(data: Data) -> Data{
       return RIPEMD160.hash(message: sha256(data: data))
    }
    
    static func sha256(data: Data) -> Data{
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
           data.withUnsafeBytes {
               _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
           }
        return Data(hash)
    }
    
    static func sha256(message: String) -> Data {
        return sha256(data: message.data(using: .utf8)!)
    }
    
    static func hash256(data: Data) -> Data {
        return sha256(data: sha256(data: data)) 
    }
    
    static func hmacSha256(key: Data , message: Data) -> Data {
        let sKey = SymmetricKey(data: key)
        let signature = HMAC<SHA256>.authenticationCode(for: message, using: sKey)
        return Data(signature)
    }
    
    static func mod(_ a: GMPInteger, _ n: GMPInteger) -> GMPInteger {
        precondition(n > 0, "modulus must be positive")
        return GMPInteger.mod(a, n)
    }


     static func encodeVarInt(_ num: UInt64) throws -> Data{
         if(num < 0xfd){
                return Data(byteArray(from: UInt8(num.littleEndian)).reversed())
         }else if(num < 0x10000){
             return Data([0xfd] + byteArray(from: UInt16(num.littleEndian)).reversed())

         }else if(num < 0x100000000){
             return Data([0xfe] + byteArray(from: UInt32(num.littleEndian)).reversed())

         }else if(num < 0xffffffffffffffff){
             return Data([0xff] + byteArray(from: UInt64(num.littleEndian)).reversed())
         }else{
             throw HelperErrors.IntTooLargeForVarInt
         }
     }

     static func decodeVarInt(_ data:Data) -> UInt64{
          let i = data.bytes.first

         if(i == 0xfd){
            return data[1...2].littleEndianUInt64()
         }else if(i == 0xfe){
             return data[1...4].littleEndianUInt64()
         }else if(i!  == 0xff){
             return data[1...8].littleEndianUInt64()
         }else{
             return UInt64(i!)
         }
     }


     static func readVarInt(_ data:InputStream) throws -> UInt64{

         let rbyte = try data.readData(maxLength: 1)
         let i = rbyte.bytes[0]

         if(i == 0xfd){
             return try data.readData(maxLength: 2).littleEndianUInt64()
         }else if(i == 0xfe){
             return try data.readData(maxLength: 4).littleEndianUInt64()
         }else if(i  == 0xff){
             return try data.readData(maxLength: 8).littleEndianUInt64()
         }else{
             return UInt64(i)
         }
     }

     static func readVarIntWithFlag(_ flag:UInt8, _ data:InputStream) throws -> UInt64{
         if(flag == 0xfd){
             return try data.readData(maxLength: 2).littleEndianUInt64()
         }else if(flag == 0xfe){
             return try data.readData(maxLength: 4).littleEndianUInt64()
         }else if(flag  == 0xff){
             return try data.readData(maxLength: 8).littleEndianUInt64()
         }else{
             return UInt64(flag)
         }
     }

     static func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
         withUnsafeBytes(of: value.bigEndian, Array.init)
     }

}

enum HelperErrors : Error {
    case IntTooLargeForVarInt
}
