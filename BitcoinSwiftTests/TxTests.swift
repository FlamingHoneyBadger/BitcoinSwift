//
// Created by FlamingHoneyBadger on 6/5/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import Foundation
import GMP
@testable import BitcoinSwift

import XCTest

class TxTests : XCTestCase {

    func testParseVersion() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        XCTAssertTrue(tx.version == 1)
    }

    func testParseInputs() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        XCTAssertEqual(tx.txIn.count, 1)
        let prevtxhash = "d1c789a9c60383bf715f3f6ad9d14b91fe55f3deb369fe5d9280cb1a01793f81"
        XCTAssertEqual(tx.txIn[0].prevTx.hexEncodedString(), prevtxhash)
        XCTAssertEqual(tx.txIn[0].prevIndex, 0)
        let prevssig = "6b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278a"
        XCTAssertEqual(try tx.txIn[0].scriptSig.Serialize().hexEncodedString(), prevssig)
        XCTAssertEqual(tx.txIn[0].sequence, 0xfffffffe)

    }

    func testParseOutputs() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        XCTAssertEqual(tx.txOut.count, 2)
        XCTAssertEqual(tx.txOut[0].amount, 32454049)
        let tx1script = "1976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac"
        XCTAssertEqual(try tx.txOut[0].scriptPubKey.Serialize().hexEncodedString(), tx1script)
        let tx2script = "1976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac"
        XCTAssertEqual(try tx.txOut[1].scriptPubKey.Serialize().hexEncodedString(), tx2script)

    }
    
    func testParseLocktime() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        XCTAssertTrue(tx.locktime == 410393)
    }
    
    
    func testSerialize() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        XCTAssertEqual(try tx.Serialize().hexEncodedString(), txString)
    }
}
