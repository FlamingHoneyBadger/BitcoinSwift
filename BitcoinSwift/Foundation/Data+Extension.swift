//
//  Data+Extension.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/22/21.
//

import Foundation
import GMP
extension Data {
    

    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    public init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }

    public var bytes: Array<UInt8> {
        Array(self)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
    
    func base58EncodeString() -> String {
        let BASE58_ALPHABET = ["1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y",
                               "Z","a","b","c","d","e","f","g","h","i","j","k","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var count  = 0
        for c in self.bytes {
            if (c == 0){
                count += 1
            }else{
                break;
            }
        }
        var num =  GMPInteger(self)  
        let prefix = String(repeating: "1", count: count)
        var result = ""
        while  (num > 0){
            var m : GMPInteger
            (num, m) =   GMPInteger.divMod(num, GMPInteger(58), GMPInteger(58))
            let mod = GMPInteger.convertToInt(m)
            result = BASE58_ALPHABET[Int(mod)] + result
        }
        result = prefix + result
        return  result
    }
    
    
    func base58EncodeWithCheckSum() -> String {
        //encode_base58(s + hash256(s)[:4])
        let s = Data(self.bytes)
        let checksum =  Helper.hash256(data: s)
        var result =  Data( s)
        result.append(checksum[0..<4])
        return result.base58EncodeString()
    }
    
}



