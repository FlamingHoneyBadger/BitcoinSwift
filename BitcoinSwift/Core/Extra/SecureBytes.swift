//
//  SecureBytes.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/23/21.
//

import Foundation


final class SecureBytes {
    
    private let bytes: Array<UInt8>
    let count: Int
    
    init(bytes: Array<UInt8>) {
        self.bytes = bytes
        self.count = bytes.count
        self.bytes.withUnsafeBufferPointer { (pointer) -> Void in
        mlock(pointer.baseAddress, pointer.count)
        }
      }
    
    deinit {
        self.bytes.withUnsafeBufferPointer { (pointer) -> Void in
        munlock(pointer.baseAddress, pointer.count)
        }
      }
    
   
}

extension SecureBytes : Collection {
    typealias Index = Int

      var endIndex: Int {
        self.bytes.endIndex
      }

      var startIndex: Int {
        self.bytes.startIndex
      }

      subscript(position: Index) -> UInt8 {
        self.bytes[position]
      }

      subscript(bounds: Range<Index>) -> ArraySlice<UInt8> {
        self.bytes[bounds]
      }

      func formIndex(after i: inout Int) {
        self.bytes.formIndex(after: &i)
      }

      func index(after i: Int) -> Int {
        self.bytes.index(after: i)
      }
}

extension SecureBytes: ExpressibleByArrayLiteral {
  public convenience init(arrayLiteral elements: UInt8...) {
    self.init(bytes: elements)
  }
}
