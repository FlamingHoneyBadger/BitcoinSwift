//
//  PrivateKey.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/22/21.
//

import Foundation
import BigInt
/*
public class PrivateKey {
    
    private let secret :SecureBytes
    let point : secp256k1Point
    
    init(key: SecureBytes) {
        self.secret = key
        self.point = BigInt(BigUInt(Data(self.secret[0..<key.count]))) * secp256k1Constants.G
        
    }
    
    func deterministicK(z: BigInt) -> BigInt{
        // method for generating determenistic K for signing from RFC 6979
        var k = Data.init(repeating: 0x00, count: 32)
        var v = Data.init(repeating: 0x01, count: 32)
        var zv = z
        if (z > secp256k1Constants.N){
            zv = zv - secp256k1Constants.N
        }
        let zBytes = z.magnitude.serialize()
        let sBytes =  Data(self.secret[0..<self.secret.count])
        
        var message =  Data()
        message.append(v)
        message.append(0x00)
        message.append(sBytes)
        message.append(zBytes)
        k = Helper.hmacSha256(key: k, message: message)
        v = Helper.hmacSha256(key: k, message: v)
        message =  Data()
        message.append(v)
        message.append(0x01)
        message.append(sBytes)
        message.append(zBytes)
        k = Helper.hmacSha256(key: k, message: message)
        v = Helper.hmacSha256(key: k, message: v)
        while (true) {
            v = Helper.hmacSha256(key: k, message: v)
            let candidate = BigInt(BigUInt(v))
            if ( candidate >= 0 && candidate < secp256k1Constants.N){
                return candidate
            }
            message = Data()
            message.append(v)
            message.append(0x00)
            k = Helper.hmacSha256(key: k, message: message)
            v = Helper.hmacSha256(key: k, message: v)
        }
    }
    
    
    func sign(z: BigInt) -> ECDSASignature {
        
        let k = self.deterministicK(z: z)
        // r is the x coordinate of kG
        guard let r = (k * secp256k1Constants.G).x?.number else { return ECDSASignature(r: 0, s: 0) }
        // get k-inv using fermat's little theorem
        let kInv =  k.power(secp256k1Constants.N - 2, modulus: secp256k1Constants.N)
        // s = (z + r * secret) / k
        var s = (((z + r) * BigInt(BigUInt(Data(self.secret[0..<self.secret.count])))) * kInv).modulus(secp256k1Constants.N)
        
        if ( s  > (secp256k1Constants.N/2)){
            s = secp256k1Constants.N - s
        }
        
        return ECDSASignature(r: r, s: s)
    }
    
    
    func verify(z: BigInt, sig: ECDSASignature) throws -> Bool {
        return try self.point.verify(z: z, sig: sig)
        
    }

    
    
}
*/
