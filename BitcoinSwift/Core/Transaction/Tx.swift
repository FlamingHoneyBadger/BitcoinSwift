//
//  Tx.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/31/21.
//

import Foundation
import GMP
class Tx {

    let version : UInt32
    let txIn : [TxIn]
    let txOut : [TxOut]
    let locktime: UInt32
    let isSegwit: Bool
    

    func SigHash(inputIndex: Int , redeemScript : Script? = nil , scriptPubkey: Script? = nil) throws -> GMPInteger {
        if(isSegwit){
            return try SigHashSegwit()
        }else{
            return try SigHashLegacy(inputIndex: inputIndex, redeemScript: redeemScript,scriptPubkey: scriptPubkey)
        }
    }
    
    
    func verifyInput(inputIndex: Int , scriptPubkey : Script  , witness: Script? = nil) throws -> Bool {
        
        let tx = txIn[inputIndex]
        
        var z : GMPInteger = GMPInteger()
        if (scriptPubkey.isP2SHScriptPubkey()){
            var rawRedeemScript = Data()
            rawRedeemScript.append(try Helper.encodeVarInt(UInt64(tx.scriptSig.storage.last!.count)))
            rawRedeemScript.append(tx.scriptSig.storage.last!)
            let redeemScript = try Script(InputStream(data: rawRedeemScript))
            if(redeemScript.isP2WPKHScriptPubkey()){
                // TODO: add segwit
            }else if (redeemScript.isP2WSHScriptPubkey()) {
                // TODO: add segwit
            }else{
                 z = try SigHash(inputIndex: inputIndex, redeemScript: redeemScript)
            }
            
        }else{
            if(scriptPubkey.isP2WPKHScriptPubkey()){
                // TODO: add segwit
            }else if(scriptPubkey.isP2WSHScriptPubkey()){
                // TODO: add segwit
            }
            
            z = try SigHash(inputIndex: inputIndex, scriptPubkey: scriptPubkey)
        }
        
        
        var combined  = tx.scriptSig
        combined.storage.append(contentsOf: scriptPubkey.storage)
        return try combined.evaluate(z: z)
    }
    
   

    func SigHashLegacy(inputIndex: Int , redeemScript : Script? = nil , scriptPubkey: Script? = nil) throws -> GMPInteger {
        var s = Data()
        // append version for hashing
        s.append(version.littleEndianBytes())
        //add how many inputs there are using encode_varint
        s.append(try Helper.encodeVarInt(UInt64(txIn.count)))

        for (i, tx) in txIn.enumerated() {
            var scriptSig :Script = Script()
            if(i == inputIndex){
                if ((redeemScript) != nil) {
                    scriptSig = redeemScript!
                }else if ((scriptPubkey) != nil){
                    scriptSig = scriptPubkey!
                }
            }

            s.append(try TxIn.init(
                    prevTx: tx.prevTx,
                    prevIndex: tx.prevIndex,
                    scriptSig: scriptSig,
                    sequence: tx.sequence)
                    .Serialize())

        }
        //add how many outputs there are using encode_varint
        s.append(try Helper.encodeVarInt(UInt64(txOut.count)))

        for item in txOut {
            s.append(try item.Serialize())

        }

        s.append(locktime.littleEndianBytes())

        s.append(Helper.SIGHASH_ALL.littleEndianBytes())
        

        return  GMPInteger(Helper.hash256(data: s))
    }

    func SigHashSegwit() throws -> GMPInteger {
        //TODO: add segwit code
        return GMPInteger()
    }

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
    
    
    func id() throws -> String {
        return try hash().hexEncodedString()
    }
    
    func hash() throws -> Data {
        return Helper.hash256(data: try Serialize())
    }


    enum TxErrors : Error {
        case ErrorParsingData
    }

}
