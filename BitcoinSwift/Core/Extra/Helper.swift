//
// Created by FlamingHoneyBadger on 5/16/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP
import CommonCrypto
import CryptoKit

 class Helper {
      static let  SIGHASH_ALL : UInt32  = 1
      static let  SIGHASH_NONE : UInt32 = 2
      static let  SIGHASH_SINGLE : UInt32 = 3

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
    
    static func hmacSha512(key: Data , message: Data) -> Data {
        let sKey = SymmetricKey(data: key)
        let signature = HMAC<SHA512>.authenticationCode(for: message, using: sKey)
        return Data(signature)
    }
    
    static func PBKDF2_HMAC_SHA512_(mnemonic: String, password: String, derivedKeyLen: Int = 64)  -> Data {
        
        let passphrase = "mnemonic"+password
        var derivedKeyData = Data(repeating:0, count:derivedKeyLen)
        
        derivedKeyData.withUnsafeMutableBytes { (output: UnsafeMutableRawBufferPointer) in
            CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), mnemonic, mnemonic.count, passphrase, passphrase.count, CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512), 2048, output.baseAddress?.assumingMemoryBound(to: UInt8.self), derivedKeyLen)
            }
       
        return derivedKeyData
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

  
    
    static func redeemScriptToP2SHAddress(_ redeemScript: Script ,  _ testnet: Bool = true) throws -> String {
        let h160 = try Helper.hash160(data: redeemScript.RawSerialize())
        var address = Data()
        
        if testnet {
            address.append(0xc4)
        }else{
            address.append(0x05)
        }
        
        address.append(h160)
        
        return address.base58EncodeWithCheckSum()
    }
    
    static func getScriptPubKey(address: String) throws -> Script {
        let raw = address.rawDecodeBase58Address()
        let type = raw.bytes[0]
        if(type == 0xc4 || type == 0x05 ){ //P2SH
            return Script.P2SHScriptPubkey(h160: address.decodeBase58Address())
        }else if( type == 0x6f || type == 0x00) {
            return Script.P2PKHScriptPubkey(h160: address.decodeBase58Address())
        }
        
        throw HelperErrors.NotSupporedOrInvalidAddress
    }
    
    
    static func merkleParent(hash1: Data, hash2: Data) -> Data {
        var data = Data()
        data.append(hash1)
        data.append(hash2)
        return hash256(data: data)
    }

    static func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        withUnsafeBytes(of: value.bigEndian, Array.init)
    }
}

enum HelperErrors : Error {
    case IntTooLargeForVarInt
    case NotSupporedOrInvalidAddress
}
