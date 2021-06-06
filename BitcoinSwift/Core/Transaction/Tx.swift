//
//  Tx.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/31/21.
//

import Foundation

class Tx {

    let version : UInt32
    let txIn : [TxIn]
    let txOut : [TxOut]
    let locktime: UInt32
    let isSegwit: Bool
    
    
    func Serialize() throws -> Data {
        if(isSegwit){
            return serializeSegwit()
        }else{
            return try serializeLegacy()
        }
    }
    
    func serializeLegacy() throws -> Data {
        var result = Data()
        result.append(version.littleEndianBytes())
        result.append(try Helper.encodeVarInt(UInt64(txIn.count)))
        for item in txIn {
            result.append(try item.Serialize())
        }
        result.append(try Helper.encodeVarInt(UInt64(txOut.count)))
        for item in txOut {
            result.append(try item.Serialize())
        }
        result.append(locktime.littleEndianBytes())
        return result
    }
    
    func serializeSegwit() -> Data {
        //TODO: add segwit code
        return Data()
    }

    init(_ input: InputStream , _ testnet: Bool = true) throws {
        input.open()
        defer {
            input.close()
        }
        let version = try input.readData(maxLength: 4)
        self.version = UInt32(version.littleEndianUInt64())
        var marker =  try input.readData(maxLength: 1)
        if(marker.bytes[0] == 0x00) {
            // segwit transaction
            isSegwit = true
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
            locktime = UInt32(try input.readData(maxLength: 4).littleEndianUInt64())

        }else{
            isSegwit = false
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
            locktime = UInt32(try input.readData(maxLength: 4).littleEndianUInt64())
       }

    }


    enum TxErrors : Error {
        case ErrorParsingData
    }

}
