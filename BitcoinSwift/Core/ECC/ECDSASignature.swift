//
//  ECDSASignature.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/20/21.
//

import Foundation
import GMP

public class ECDSASignature  {


    var r :GMPInteger
    var s: GMPInteger
    
    public init(r: GMPInteger, s: GMPInteger) {
        self.r = r
        self.s = s
    }
    
    public func description() -> String {
        return "Signature(\(r) ,\(s))"
    }
    
    
    public func DERBytes() -> Data {
        var prefix = Data(repeating:0x30,count:1)
        var rbin = Data(GMPInteger.bytes(r))
        var sbin = Data(GMPInteger.bytes(s))
        var result = Data()

        if((rbin.first! & 0x80) != 0){
            rbin =  Data(repeating:0x00,count:1)
            rbin.append(Data(GMPInteger.bytes(r)))
        }
        result.append(0x02)
        result.append(UInt8(rbin.count))
        result.append(rbin)

        if((sbin.first! & 0x80) != 0){
            sbin =  Data(repeating:0x00,count:1)
            sbin.append(Data(GMPInteger.bytes(s)))
        }
        result.append(0x02)
        result.append(UInt8(sbin.count))
        result.append(sbin)

        prefix.append(UInt8(result.count))
        prefix.append(result)
        return prefix
    }
    
    
    

}
