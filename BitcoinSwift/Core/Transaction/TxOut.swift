//
// Created by FlamingHoneyBadger on 5/31/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import SwiftGMP

class TxOut {
    
    var amount : UInt64
    var scriptPubKey : Script
    
    init(amount: UInt64, scriptPubKey: Script) {
        self.amount = amount
        self.scriptPubKey = scriptPubKey
    }

    init(_ input: InputStream) throws {
        amount = try input.readData(maxLength: 8).littleEndianUInt64()
        scriptPubKey = try Script.init(input)
    }
    func Serialize() throws -> Data {
        var result = Data()
        result.append(amount.littleEndianBytes())
        result.append(try scriptPubKey.Serialize())
        return result
    }
}
