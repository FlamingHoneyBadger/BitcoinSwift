//
//  ECDSASignature.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/20/21.
//

import Foundation
import BigInt

public class ECDSASignature : NSObject {


    let r :BigInt
    let s: BigInt
    
    public init(r: BigInt, s: BigInt) {
        self.r = r
        self.s = s
    }
    
    
    public func DERBytes() -> Data {
        var prefix = Data(repeating:0x30,count:1)
        var rbin = Data(r.magnitude.serialize())
        var sbin = Data(s.magnitude.serialize())
        var result = Data()

        if((rbin.first! & 0x80) != 0){
            rbin =  Data(repeating:0x00,count:1)
            rbin.append(r.magnitude.serialize())
        }
        result.append(0x02)
        result.append(UInt8(rbin.count))
        result.append(rbin)
        
        if((sbin.first! & 0x80) != 0){
            sbin =  Data(repeating:0x00,count:1)
            sbin.append(s.magnitude.serialize())
        }
        result.append(0x02)
        result.append(UInt8(sbin.count))
        result.append(sbin)
        
        prefix.append(UInt8(result.count))
        prefix.append(result)
        return prefix
    }
    
    
    

}
