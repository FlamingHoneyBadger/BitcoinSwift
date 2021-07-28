//
//  BitReader.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 7/25/21.
//

import Foundation

struct BitReader {
    private let data : [UInt8]
    private var byteOffset = 0
    private var currentValue : UInt = 0 // Bits which still have to be consumed
    private var currentBits = 0         // Number of valid bits in `currentValue`

    init(data : [UInt8]) {
        self.data = data
    }

    func remainingBits() -> Int {
        return 8 * (data.count - byteOffset) + currentBits
    }

    mutating func nextBits(numBits : Int) -> Data {
        precondition(numBits <= remainingBits(), "attempt to read more bits than available")

        // Collect bytes until we have enough bits:
        while currentBits < numBits {
            currentValue = (currentValue << 8) + UInt(data[byteOffset])
            currentBits = currentBits + 8
            byteOffset = byteOffset + 1
        }

        // Extract result:
        let remaining = currentBits - numBits
        let result = currentValue >> UInt(remaining)

        // Update remaining bits:
        currentValue = currentValue & UInt(1 << remaining - 1)
        currentBits = remaining
        return result.littleEndianBytes()
    }

}
