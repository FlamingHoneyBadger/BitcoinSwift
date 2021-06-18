//
//  String+Extension.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 6/18/21.
//

import Foundation
import GMP

extension String {
    func rawDecodeBase58Address() -> Data {
        let BASE58_ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

        var num  = GMPInteger(0)
        
        
        for c in self {
            num = num *  58
            let i = BASE58_ALPHABET.firstIndex(of: c)
            num = num + BASE58_ALPHABET.distance(from: BASE58_ALPHABET.startIndex, to: i!)
        }
        
        
        let combined = GMPInteger.bytes(num)
        
        return Data(combined)
    }
    
    
    func decodeBase58Address() -> Data {
        let raw = self.rawDecodeBase58Address().bytes
        
        return Data(raw[1..<raw.count-4])
    }
}
