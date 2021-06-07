//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation

class TxIn {

    var prevTx : Data
    var prevIndex : UInt32
    var scriptSig : Script
    var sequence : UInt32
    
    init(_ input: InputStream) throws {
        prevTx = try Data(input.readData(maxLength: 32).reversed())
        prevIndex = UInt32(try input.readData(maxLength: 4).littleEndianUInt64())
        scriptSig = try Script.init(input)
        sequence = UInt32(try input.readData(maxLength: 4).littleEndianUInt64())
        
    }
    init(prevTx : Data ,prevIndex : UInt32,scriptSig : Script,sequence : UInt32)  {
        self.prevTx = prevTx
        self.prevIndex = prevIndex
        self.scriptSig = scriptSig
        self.sequence = sequence
    }


    func Serialize() throws -> Data {
        var result = Data()
        result.append(Data(prevTx.reversed()))
        result.append(prevIndex.littleEndianBytes())
        result.append(try scriptSig.Serialize())
        result.append(sequence.littleEndianBytes())
        return result
    }
}
