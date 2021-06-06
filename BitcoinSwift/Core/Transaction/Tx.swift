//
//  Tx.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/31/21.
//

import Foundation

class Tx {

    let version : UInt64
    let txIn : [TxIn]
    let txOut : [TxOut]
    let locktime: UInt64

    init(_ input: InputStream , _ testnet: Bool = true) throws {
        input.open()
        defer {
            input.close()
        }
        let version = try input.readData(maxLength: 4)
        self.version = version.littleEndianUInt64()
        var marker =  try input.readData(maxLength: 1)
        if(marker.bytes[0] == 0x00) {
            // segwit transaction
            //marker.append(try input.readData(maxLength: 1))
            // legacy transaction
            var numInputs = try Helper.readVarIntWithFlag(marker.bytes[0], input)
            var txIns :[TxIn] = []

            while numInputs > 0 {
                txIns.append(try TxIn.init(input))
                numInputs -= 1
            }
            var numOutput = try Helper.readVarInt(input)
            var txOuts :[TxOut] = []

            while numOutput > 0 {
                txOuts.append(try TxOut.init(input))
                numOutput -= 1
            }
            txOut = txOuts
            txIn = txIns
            locktime = try input.readData(maxLength: 4).littleEndianUInt64()

        }else{
            // legacy transaction
            var numInputs = try Helper.readVarIntWithFlag(marker.bytes[0], input)
            var txIns :[TxIn] = []
            while numInputs > 0 {
                let txin = try TxIn.init(input)
                txIns.append(txin)
                numInputs -= 1
            }
            var numOutput = try Helper.readVarInt(input)
            var txOuts :[TxOut] = []
            while numOutput > 0 {
                txOuts.append(try TxOut.init(input))
                numOutput -= 1
            }
            txOut = txOuts
            txIn = txIns
            locktime = try input.readData(maxLength: 4).littleEndianUInt64()
       }

    }


    enum TxErrors : Error {
        case ErrorParsingData
    }

}
