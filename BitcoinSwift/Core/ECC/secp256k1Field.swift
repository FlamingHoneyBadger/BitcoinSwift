//
// Created by FlamingHoneyBadger on 5/16/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import BigInt


class secp256k1Field : FieldElement {
    
    
    public override var description: String {
        return "(\(number))"
    }
    
     init(num: BigInt) {
        super.init(num: num, prime: secp256k1Constants.P)
        
     }
    func sqrt() -> secp256k1Field{
        let div = ((secp256k1Constants.P + BigInt(1)).quotientAndRemainder(dividingBy: 4))
        let s = self ^^ (div.quotient)
        return  secp256k1Field.init(num: s.number)
    }
    
    
    
    
    
    
    
    

}
