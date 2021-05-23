//
//  ECDSASignature.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/20/21.
//

import Foundation
import BigInt
class ECDSASignature : NSObject {


    let r :BigInt
    let s: BigInt
    
    init(r: BigInt, s: BigInt) {
        self.r = r
        self.s = s
    }
    
    

}
