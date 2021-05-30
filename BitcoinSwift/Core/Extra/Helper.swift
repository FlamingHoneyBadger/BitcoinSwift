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


    

}
