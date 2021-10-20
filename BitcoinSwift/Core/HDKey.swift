//
//  HDKey.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 10/9/21.
//  Pretty much just Bip32 used as baseclass

import Foundation
import GMP

enum HDKeyErrors :Error {
    case checksumsDontMatch
    case versionBytesDontMatch
    case keySECPrefixMismatch
    case zeroDepthWithNonZeroParentFingerprint
    case zeroDepthWithNonZeroIndex
    
}
class Bip32HDKey {
    
    
    let key:Data  //33 bytes / 1 byte padding
    let pkey:PrivateKey?
    let pubkey:secp256k1Point?
    let version:Data // 4 bytes
    let childNumber:Data // 4 bytes
    let childIndex:UInt32
    let fingerPrint:Data // 4 bytes
    let chainCode:Data // 32 bytes
    let depth:UInt8
    let isPrivate:Bool
    let FirstHardenedChild:UInt32 = UInt32(0x80000000)

    init(key:Data,version:Data,childNumber:Data,fingerPrint:Data,chainCode:Data,depth:UInt8,isPrivate:Bool) throws{
        self.key = key
        self.version = version
        self.childNumber = childNumber
        self.childIndex =  childNumber.reduce(0) { $0 << 8 + UInt32($1) }
        self.fingerPrint = fingerPrint
        self.chainCode = chainCode
        self.depth = depth
	        self.isPrivate = isPrivate
        if self.isPrivate {
            self.pkey = try PrivateKey.init(key: SecureBytes.init(bytes: key.bytes))
            self.pubkey = pkey?.point
        }else{
            self.pkey = nil
            self.pubkey = secp256k1Point.parse(data: key)
        }
    }

     init(input:InputStream) throws {
        input.open()
        defer {
            input.close()
        }
        
        version = try input.readData(maxLength: 4)
        depth = try input.readData(maxLength: 1).first ?? 0
        fingerPrint = try input.readData(maxLength: 4)
        childNumber = try input.readData(maxLength: 4)
        chainCode = try input.readData(maxLength: 32)
        let privFlag = try input.readData(maxLength: 1).first ?? 0
        
        childIndex =  childNumber.reduce(0) { $0 << 4 + UInt32($1) }
         
         if(depth == 0 && childIndex != 0){
             throw HDKeyErrors.zeroDepthWithNonZeroIndex
         }
         
         if(depth == 0 && fingerPrint.bytes != [0x00,0x00,0x00,0x00]){
             throw HDKeyErrors.zeroDepthWithNonZeroParentFingerprint
         }

        
        if(privFlag == 0){
            isPrivate = true
            key = try input.readData(maxLength: 32)
            self.pkey = try PrivateKey.init(key: SecureBytes.init(bytes: key.bytes))
            self.pubkey = pkey?.point

        }else if(privFlag != 0x03 || privFlag != 0x02){
            throw HDKeyErrors.keySECPrefixMismatch
        }else{
            isPrivate = false
            var keyData = Data()
            keyData.append(privFlag)
            keyData = try input.readData(maxLength: 32)
            key = keyData
            self.pkey = nil
            self.pubkey = secp256k1Point.parse(data: key)
        }
   
        let inputChecksum = try input.readData(maxLength: 4)
        
        var data = Data()
        data.append(version)
        data.append(depth)
        data.append(fingerPrint)
        data.append(childNumber)
        data.append(chainCode)
         if( isPrivate){
             data.append(contentsOf: [0x00])
         }
         data.append(key)
         let calculatedchecksum = Helper.hash256(data: data)[0...3]
         
        
         if(version == getVersionBytes(isPrivate: isPrivate, isTestnet: true) ||
            version == getVersionBytes(isPrivate: isPrivate, isTestnet: false)){
             
         } else {
             throw HDKeyErrors.versionBytesDontMatch
         }

         if (calculatedchecksum != inputChecksum ){
             throw HDKeyErrors.checksumsDontMatch
         }
    
    }
    
    
    
    func Serialize(isPrivate:Bool = true ,isTestnet:Bool = true ) -> Data {
        var data = Data()
        data.append(getVersionBytes(isPrivate: isPrivate, isTestnet: isTestnet))
        data.append(depth)
        data.append(fingerPrint)
        data.append(childNumber)
        data.append(chainCode)
        if(self.isPrivate && isPrivate){
            data.append(contentsOf:[0x00]) // private key byte padding 
            data.append(key)
        }
        else if(self.isPrivate && !isPrivate){
            data.append(pkey!.point.SecBytes(isCompressed: true))
        }
        
        return data

    }
    
     
    func getVersionBytes(isPrivate: Bool = false  , isTestnet:Bool = false ) -> Data {
        var data = Data();
        if(isPrivate){
            if(isTestnet){
                data.append(contentsOf: [0x04,0x35,0x83,0x94]) // Version for private test
            }else{
                data.append(contentsOf: [0x04,0x88,0xAD,0xE4])// Version for private mainnet
            }
        }
        else{
            if(isTestnet){
                data.append(contentsOf: [0x04,0x35,0x87,0xCF]) // Version for public test
            }else{
                data.append(contentsOf:[0x04,0x88,0xB2,0x1E])// Version for public mainnet
            }
        }
        return data
    }
    
    func generateChild(childIndex:UInt32, isTestnet:Bool = true) throws -> Bip32HDKey {
        assert(!(!self.isPrivate && childIndex >= FirstHardenedChild))
        
        let intermediary = getIntermediary(childIndex: childIndex)
        
        if(self.isPrivate){
            let fingerprint = Helper.hash160(data: pkey!.point.SecBytes(isCompressed: true))
            let inet = GMPInteger.init(intermediary[0...31])
            let k = GMPInteger.init(self.key)
            let rkey = ( inet + k ) % secp256k1Constants.N
            
            let key =  Data(GMPInteger.bytes(rkey))
            let returnKey = try Bip32HDKey(key:key, version: getVersionBytes(isPrivate: self.isPrivate, isTestnet: isTestnet), childNumber: childIndex.bigEndianBytes(), fingerPrint: fingerprint[0..<4], chainCode: intermediary[32...intermediary.count-1], depth: self.depth+1, isPrivate: isPrivate)
            
            return returnKey
            
        }else{
            let kb = try PrivateKey(key: SecureBytes(bytes:Data(intermediary[32..<intermediary.count]).bytes))
            let fingerprint = Helper.hash160(data: pkey!
                                                .point.SecBytes(isCompressed: true))
            let ckey = (kb.point.point + pkey!.point.point)
            let childkey = secp256k1Point(p: ckey)
            let returnKey = try Bip32HDKey(key: childkey.SecBytes(isCompressed: true) , version: getVersionBytes(isPrivate: self.isPrivate, isTestnet: isTestnet), childNumber: childIndex.bigEndianBytes(), fingerPrint: fingerprint[0..<4], chainCode: intermediary[0..<32], depth: self.depth+1, isPrivate: isPrivate)
            
            return returnKey
            
        }
        
        
        
    }
    
    func getIntermediary(childIndex:UInt32) -> Data {
        
        var data = Data()
        if (childIndex >= self.FirstHardenedChild){
            data.append(contentsOf: [0x00])
            data.append(key)
        }else {
            if isPrivate {

                data.append(pkey!.point.SecBytes(isCompressed: true))
            }else{
                data.append(key)
            }
        }
        
        data.append(childIndex.bigEndianBytes())
        return Helper.hmacSha512(key: chainCode, message: data)
      
        
    }
    
    
    
    
    

}
