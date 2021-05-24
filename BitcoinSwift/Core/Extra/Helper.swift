//
// Created by FlamingHoneyBadger on 5/16/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import BigInt
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
    
    static func hash256(data: Data) -> Data {
        return sha256(data: sha256(data: data)) 
    }
    
    static func hmacSha256(key: Data , message: Data) -> Data {
        let sKey = SymmetricKey(data: key)
        let signature = HMAC<SHA256>.authenticationCode(for: message, using: sKey)
        return Data(signature)
    }
    
    
    static func powMod(base: BigInt, exponent: BigInt, modulo: BigInt) -> BigInt {
        var b : BigInt =  exponent
        var x : BigInt = 1
        var y : BigInt =  base
        while (b > 0) {
            if (mod(b,2) == 1) {
                x = (mod( (x * y) , modulo)) // multiplying with base
            }
            y = mod( (y * y) , modulo) // squaring the base
            b = b / 2
        }
        return x % modulo
    }
    

    static func mod(_ a: BigInt, _ n: BigInt) -> BigInt {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }

    static func pow( base: BigInt,  exponent: BigInt) -> BigInt {
        var result = BigInt(1)
        var b = BigInt(exponent)
        var y = base
        while (b > 0){
            if (Helper.mod(b,2) == 1){
                result *= base
            }
            b /= 2
            y *= y
        }
        return result
    }
    

}
