//
// Created by FlamingHoneyBadger on 6/4/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import XCTest
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


}