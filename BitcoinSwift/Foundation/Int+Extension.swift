//
// Created by FlamingHoneyBadger on 6/6/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation


extension UInt64 {
    func littleEndianBytes() -> Data {
         Data(withUnsafeBytes(of: littleEndian, Array.init))
    }
    func bigEndianBytes() -> Data {
         Data(withUnsafeBytes(of: bigEndian, Array.init))
    }
}

extension UInt {
    func littleEndianBytes() -> Data {
         Data(withUnsafeBytes(of: littleEndian, Array.init))
    }
    func bigEndianBytes() -> Data {
         Data(withUnsafeBytes(of: bigEndian, Array.init))
    }
}

extension UInt32 {
    func littleEndianBytes() -> Data {
        Data(withUnsafeBytes(of: littleEndian, Array.init))
    }
    func bigEndianBytes() -> Data {
         Data(withUnsafeBytes(of: bigEndian, Array.init))
    }
}

extension UInt16 {
    func littleEndianBytes() -> Data {
        Data(withUnsafeBytes(of: littleEndian, Array.init))
    }
    func bigEndianBytes() -> Data {
         Data(withUnsafeBytes(of: bigEndian, Array.init))
    }
}

extension UInt8 {
    func littleEndianBytes() -> Data {
        Data(withUnsafeBytes(of: littleEndian, Array.init))
    }
    func bigEndianBytes() -> Data {
         Data(withUnsafeBytes(of: bigEndian, Array.init))
    }
}
