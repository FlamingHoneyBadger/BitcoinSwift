//
// Created by FlamingHoneyBadger on 6/5/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP
@testable import BitcoinSwift

import XCTest

class ScriptTests : XCTestCase {

        func testParse() throws {
             let script_pubkey = "6a47304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a7160121035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937"
            let input = InputStream.init(data: script_pubkey.hexadecimal!)
            input.open()
            let script = try Script.init(input)
            input.close()
            print(script.description)
            XCTAssertEqual("304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a71601"
                    , script.storage[0].hexEncodedString())
            XCTAssertEqual("035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937"
                    , script.storage[1].hexEncodedString())
        }


        func testSerialize() throws {
            let script_pubkey = "6a47304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a7160121035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937"
            let input = InputStream.init(data: script_pubkey.hexadecimal!)
            input.open()
            let script = try Script.init(input)
            input.close()
            let result = try script.Serialize()
            print(script_pubkey)
            print(result.hexEncodedString())
        }
}
