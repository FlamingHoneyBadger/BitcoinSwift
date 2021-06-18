//
//  HelperTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/23/21.
//

import Foundation
import XCTest
@testable import BitcoinSwift

class HelperTests : XCTestCase{
    
    func testSha256() throws {
        let a = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        XCTAssertEqual(a,Helper.sha256(data: Data()).hexEncodedString())
    }

    func testVarInt() throws {
        let i = UInt64(15555555)
        let a = try Helper.encodeVarInt(i)
        XCTAssertEqual("fee35bed00",a.hexEncodedString())
        let b = Helper.decodeVarInt(a)
        XCTAssertEqual(i,b)
    }

    func testVarInt1() throws {

        let i = UInt64(15555555)
        var a = try Helper.encodeVarInt(i)
        XCTAssertEqual("fee35bed00",a.hexEncodedString())
        var stream = InputStream.init(data: a)
        stream.open()
        defer {
            stream.close()
        }
        let b = try Helper.readVarInt(stream)
        XCTAssertEqual(i,b)
    }
    
    func testP2SH2of3Address() throws {
        //e,e2,e3
        let e  = PrivateKey.init(key: SecureBytes.init(bytes:"9d8077db6902d4bdbbeafee3a19a152914aaf1f3de03352badc48b21e0f7fa97".hexadecimal!.bytes))
        let e2 = PrivateKey.init(key: SecureBytes.init(bytes:"1514739c40ffc689a557fed1f26fd9dec39a53eb06378298d2a6f0e648a46dfa".hexadecimal!.bytes))
        let e3 = PrivateKey.init(key: SecureBytes.init(bytes:"6a3a2cf5fe317ed4a6773836f48a53b302506cbcbf1a95a09eb81c0ca3617213".hexadecimal!.bytes))
        var redeemScript = Script()
        redeemScript.push(Data([82]))
        redeemScript.push(e.point.SecBytes(isCompressed: true))
        redeemScript.push(e2.point.SecBytes(isCompressed: true))
        redeemScript.push(e3.point.SecBytes(isCompressed: true))
        redeemScript.push(Data([83]))
        redeemScript.push(Data([174]))
        
       XCTAssertEqual(try Helper.redeemScriptToP2SHAddress(redeemScript),"2NF73E7PMwxUHJKcEcgU6ENdotPZL23TT1H")

    }
    
    func testP2SH1of1Address() throws {
        //e,e2,e3
        let e  = PrivateKey.init(key: SecureBytes.init(bytes:"9d8077db6902d4bdbbeafee3a19a152914aaf1f3de03352badc48b21e0f7fa97".hexadecimal!.bytes))
        var redeemScript = Script()
        redeemScript.push(Data([OP_CODE_FUNCTIONS.OP_1.rawValue]))
        redeemScript.push(e.point.SecBytes(isCompressed: true))
        redeemScript.push(Data([OP_CODE_FUNCTIONS.OP_1.rawValue]))
        redeemScript.push(Data([174]))
        
       XCTAssertEqual(try Helper.redeemScriptToP2SHAddress(redeemScript),"2N9aRqE8fmc6Q5vcjK5XH1QbEYjDRmm5EuU")

    }
    
    
    
    
    
}
