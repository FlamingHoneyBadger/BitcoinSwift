//
//  Block.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 6/22/21.
//

import Foundation
import GMP



class Block {
    static let RAW_GENESIS_BLOCK : Data = "0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c"
    static let RAW_TESTNET_GENESIS_BLOCK : Data = "0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4adae5494dffff001d1aa4ae18"
    static let LOWEST_BITS : Data = "ffff001d"
    
    let version : UInt32
    let timestamp : UInt32
    let prevBlock : Data
    let merkleRoot : Data
    let bits : Data
    let nonce : Data
    var txHashes : [Data]

    
    init(version: UInt32, prevBlock: Data, merkleRoot: Data, timestamp: UInt32 , bits: Data,  nonce:Data, txHashes: [Data] = []) {
        self.version = version
        self.timestamp = timestamp
        self.prevBlock = prevBlock
        self.bits = bits
        self.merkleRoot = merkleRoot
        self.nonce = nonce
        self.txHashes = txHashes
        
    }
    
    convenience init(data: Data) throws {
        try self.init(input:InputStream(data: data))
    }
    
    
    init(input: InputStream) throws {
        input.open()
        defer {
            input.close()
        }
        
        self.version = UInt32(try input.readData(maxLength: 4).littleEndianUInt64())
        
        self.prevBlock = Data( try input.readData(maxLength: 32).reversed())
        
        self.merkleRoot = Data( try input.readData(maxLength: 32).reversed())
        
        self.timestamp = UInt32(try input.readData(maxLength: 4).littleEndianUInt64())
        
        self.bits = try input.readData(maxLength: 4)
        
        self.nonce = try input.readData(maxLength: 4)
        
        self.txHashes = []
    }
    
    func serialize() -> Data {
        var result = Data()
        result.append(version.littleEndianBytes())
        result.append(Data(prevBlock.reversed()))
        result.append(Data(merkleRoot.reversed()))
        result.append(timestamp.littleEndianBytes())
        result.append(bits)
        result.append(nonce)
        return result
    }
    
    func hash() -> Data {
        var result = Helper.hash256(data: serialize())
        result.reverse()
        return result
    }
    
    
    public var bip9 : Bool {
        // checks the top 3 bits for bit 9 signal
        version >> 29 == 0x001
    }
    
    public var bip91 : Bool {
        // checks 5th bit for bip 91 signal
        version >> 4 & 1 == 1
    }
    
    public var bip141 : Bool {
        // checks 2nd bit for bip 141 singal
        version >> 1 & 1  == 1
    }
    
    func difficulty() -> GMPInteger {

        var lowest = GMPInteger("26959535291011309493156476344723991336010898738574164086137773096960")
        var target = target()
        print(lowest.description)//26959535291011309493156476344723991336010898738574164086137773096960
        target =  GMPInteger("30353962581764818649842367179120467226026534727449575424")
        print(" / ")
        print(target.description) //30353962581764818649842367179120467226026534727449575424
    
        return lowest / target
    }
    
    func checkPOW() -> Bool {
        // serialize block and hash
        var h256 = Helper.hash256(data: serialize())
        h256.reverse()
        // interpret the hash as a little-endian number
        let proof = GMPInteger(h256)
        // proof should be less than the target
        return proof < target()
    }
    
    func validateMerkleRoot() -> Bool{
        var hashes = txHashes
        for  i in hashes.indices {
            hashes[i].reverse()
        }
        print(hashes[0].hexEncodedString())
        let tree : MerkleTree
        
        do{
        tree = try MerkleTree(hashes: hashes)
        }catch{
            return false
        }
        return merkleRoot.bytes == tree.root()?.reversed()
        
    }
    
    func target() -> GMPInteger {
        let exp = bits.bytes[3]
        
        let coefficient = Data(bits.bytes[0...2]).littleEndianUInt64()
        
        let result = GMPInteger(Int(coefficient)) * GMPInteger.pow(GMPInteger(256), (UInt(exp) - 3))
        return result
        
    }
    
    
}
