//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation

class TxIn {

    var prevTx : Data
    var prevIndex : UInt64
    var scriptSig : Script
    var sequence : UInt64
    
    init(_ input: InputStream) throws {
        prevTx = try Data(input.readData(maxLength: 32).reversed())
        prevIndex = try input.readData(maxLength: 4).littleEndianUInt64()
        scriptSig = try Script.init(input)
        sequence =  try input.readData(maxLength: 4).littleEndianUInt64()
        
    }

}
