//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP

class TxOut {
    
    var amount : GMPInteger
    var scriptPubKey : Script

    init(_ input: InputStream) throws {
        amount =  GMPInteger(Data(try input.readData(maxLength: 8).reversed()))
        scriptPubKey = try Script.init(input)
    }

}
