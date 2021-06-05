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
    
}
