//
// Created by FlamingHoneyBadger on 5/16/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import SwiftGMP


struct secp256k1Field  {
    var element : FieldElement
    
    
    
    public  var description: String {
        return "(\(element))"
    }
    
     init(num: GMPInteger) {
        element = FieldElement(num: num, prime: secp256k1Constants.P)
        
     }
    
}
    
    
    extension secp256k1Field {
        func sqrt() -> secp256k1Field{
            let div = ((secp256k1Constants.P + 1) / GMPInteger(4))
            let s = element ^^ (div)
            return  secp256k1Field.init(num: s.number)
        }
        
    }
    
    
    
    
    
    
    
    


