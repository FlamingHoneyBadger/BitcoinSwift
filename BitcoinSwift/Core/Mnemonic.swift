//
//  Mnemonic.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 7/25/21.
//

import Foundation
import CryptoKit

class Mnemonic {
    let mnemonicWordListArray:[String]
    var mnemonicWordList:String { return self.mnemonicWordListArray.joined(separator: " ")}
    let entropy:Int
    private let testnet:Bool
    
    /*
     CS = ENT / 32
     MS = (ENT + CS) / 11

     |  ENT  | CS | ENT+CS |  MS  |
     +-------+----+--------+------+
     |  128  |  4 |   132  |  12  |
     |  160  |  5 |   165  |  15  |
     |  192  |  6 |   198  |  18  |
     |  224  |  7 |   231  |  21  |
     |  256  |  8 |   264  |  24  |
     
     */
  
    
    init(input: Data, testnet: Bool = true)  {
        self.testnet = testnet
        self.entropy = input.count * 8
        self.mnemonicWordListArray = Mnemonic.calculateMnemonicString(input: input)
        assert(self.entropy >= 128 && self.entropy <= 256 && self.entropy % 32 == 0)
    }
    
    
    func toSeed(passphrase: String = "") -> Data {
        return  Helper.PBKDF2_HMAC_SHA512_(mnemonic: self.mnemonicWordList, password: passphrase)
    }
    
    func toHDMasterKey(passphrase: String = "") -> Data {
        let seed = toSeed(passphrase: passphrase)
        assert(seed.count == 64)
        let seed1 = Helper.hmacSha512(key:Data("Bitcoin seed".utf8), message: seed)
        var xprv = Data();
        if(testnet){
            xprv.append(contentsOf: [0x04,0x35,0x83,0x94]) // Version for private test
        }else{
            
            xprv.append(contentsOf: [0x04,0x88,0xad,0xe4])// Version for private mainnet
        }
        xprv.append(Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]))
        xprv.append(seed1[32...seed.count-1]) //chain code
        xprv.append(0x00)
        xprv.append(seed1[0...31]) // master key
        return xprv
    }
    
    static func getSeed(mnemonic:String , passphrase: String = "") -> Data {
        return  Helper.PBKDF2_HMAC_SHA512_(mnemonic: mnemonic, password: passphrase)
    }
    
   static func calculateMnemonicString(input: Data) -> [String] {
        var inputBytes = input
        inputBytes.append( Helper.sha256(data: input)[0]) //CS byte
        var bitreader = BitReader.init(data: inputBytes.bytes)
        var wordsrray:[String] = []
        while bitreader.remainingBits() >= 11{
            let a = bitreader.nextBits(numBits: 11)
            let value = a.withUnsafeBytes {
                $0.load(as: UInt16.self)
            }
            wordsrray.append(Wordlists.english[Int(UInt(value))])
        }
       
        return wordsrray;
    }
    
    
    
}
