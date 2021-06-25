//
//  PrivateKey.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/22/21.
//

import Foundation
import SwiftGMP

public class PrivateKey {
    
    private let secret :SecureBytes
    let point : secp256k1Point
    
    init(key: SecureBytes) {
        self.secret = key
        self.point = secp256k1Point.init(p: GMPInteger(Data(self.secret[0..<key.count])) * secp256k1Constants.G.point) 
        
    }
    
    func deterministicK(z: GMPInteger) -> GMPInteger{
        // method for generating determenistic K for signing from RFC 6979
        var k = Data.init(repeating: 0x00, count: 32)
        var v = Data.init(repeating: 0x01, count: 32)
        var zv = z
        if (z > secp256k1Constants.N){
            zv = zv - secp256k1Constants.N
        }
        let zBytes =  Data(GMPInteger.bytes(zv))
        var sBytes : Data
        if(self.secret.count < 32){
            sBytes =  Data.init(count: 32)
            sBytes.replaceSubrange(32-self.secret.count...31, with: Data(self.secret[0..<self.secret.count]))
        }else{
            sBytes =  Data(self.secret[0..<self.secret.count])
        }

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
            let candidate = GMPInteger(v)
            if ( candidate >= GMPInteger(0) && candidate < secp256k1Constants.N){
                return candidate
            }
            message = Data()
            message.append(v)
            message.append(0x00)
            k = Helper.hmacSha256(key: k, message: message)
            v = Helper.hmacSha256(key: k, message: v)
        }
    }
    
    
    func signWithECDSA(z: GMPInteger) -> ECDSASignature {
        let k = self.deterministicK(z:z)
        // r is the x coordinate of kG
        let r = (k * secp256k1Constants.G.point).x
        // get k-inv using fermat's little theorem
        let kInv =  GMPInteger.powMod(k, secp256k1Constants.N - 2, secp256k1Constants.N)
        // s = (z + r * secret) / k
        var s = (z + r! * GMPInteger(Data(self.secret[0..<self.secret.count]))) * kInv % secp256k1Constants.N
        
        if ( s  > (secp256k1Constants.N / GMPInteger(2))){
            s = secp256k1Constants.N - s
        }
        
        return ECDSASignature(r: r!, s: s)
    }
    
    func wif(compressed: Bool = true , testnet: Bool = true) -> String {
        
        let secretBytes = Data(self.secret[0..<self.secret.count])
        var wif = Data()
        
        if(testnet){
            wif.append(0xef)
        }else{
            wif.append(0x80)
        }
        wif.append(secretBytes)
        if(compressed){
            wif.append(0x01)
        }
        
        return wif.base58EncodeWithCheckSum()
    }
    
    
    func verify(z: GMPInteger, sig: ECDSASignature) throws -> Bool {
        return self.point.verify(z: z, sig: sig)
    }

}

