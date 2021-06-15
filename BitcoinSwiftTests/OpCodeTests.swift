//
// Created by FlamingHoneyBadger on 6/4/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import XCTest
import GMP

@testable import BitcoinSwift

class OpCodeTests : XCTestCase {

    func testEncodeNumber(){
        var a =  encodeNum(num: 15555555)
        XCTAssertEqual("e35bed00", a.hexEncodedString())
        XCTAssertEqual(15555555, decodeNum(num: a.bytes))
        a =  encodeNum(num: -15555555)
        XCTAssertEqual("e35bed80", a.hexEncodedString())
        XCTAssertEqual(-15555555, decodeNum(num: a.bytes))

    }
    
    
    func testOpHash160(){
        var stack = Script()
        var a = Script()
        var b = Script()
        stack.push("hello world".data(using: String.Encoding.ascii)!)
        XCTAssertTrue(OPHASH160.execute(&a, stack: &stack, altStack: &b, z: nil))
        
        let hash =  stack.pop()?.hexEncodedString()
        
        XCTAssertEqual(hash, "d7d5ee7824ff93f94c3055af9382c86c68b5ca92")
        
    }
    
    
    func testOpCheckSig(){
        let secHex = "04887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34"
        let sigHex = "3045022000eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c022100c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab601"
        let z = GMPInteger("7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d".hexadecimal!)
        var stack = Script()
        var a = Script()
        var b = Script()
        stack.push(sigHex.hexadecimal!)
        stack.push(secHex.hexadecimal!)

        XCTAssertTrue(OPCHECKSIG.execute(&a, stack: &stack, altStack: &b, z: z))
        XCTAssertEqual(decodeNum(num: stack.pop()!.bytes) , 1)
        
    }
    
    func testOpCheckMultiSig(){
        let sec1Hex = "022626e955ea6ea6d98850c994f9107b036b1334f18ca8830bfff1295d21cfdb70"
        let sig1Hex = "3045022100dc92655fe37036f47756db8102e0d7d5e28b3beb83a8fef4f5dc0559bddfb94e02205a36d4e4e6c7fcd16658c50783e00c341609977aed3ad00937bf4ee942a8993701"
        let sec2Hex = "03b287eaf122eea69030a0e9feed096bed8045c8b98bec453e1ffac7fbdbd4bb71"
        let sig2Hex = "3045022100da6bee3c93766232079a01639d07fa869598749729ae323eab8eef53577d611b02207bef15429dcadce2121ea07f233115c6f09034c0be68db99980b9a6c5e75402201"
        let z = GMPInteger("e71bfa115715d6fd33796948126f40a8cdd39f187e4afb03896795189fe1423c".hexadecimal!)
        var stack = Script()
        var a = Script()
        var b = Script()
        
        stack.push(Data())
        stack.push(sig1Hex.hexadecimal!)
        stack.push(sig2Hex.hexadecimal!)
        stack.push(Data([UInt8(0x02)]))
        stack.push(sec1Hex.hexadecimal!)
        stack.push(sec2Hex.hexadecimal!)
        stack.push(Data([UInt8(0x02)]))
        
        XCTAssertTrue(OPCHECKMULTISIG.execute(&a, stack: &stack, altStack: &b, z: z))
        XCTAssertEqual(decodeNum(num: stack.pop()!.bytes) , 1)
        
    }
    


}
