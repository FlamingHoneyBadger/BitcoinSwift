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

    func testLegacySigHash() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let scriptPubkey = "1976a914a802fc56c704ce87c42d7c92eb75e7896bdc41ae88ac"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        var input = InputStream(data: scriptPubkey.hexadecimal!)
        input.open()
        let script = try Script.init(input)
        input.close()
        let sigHash = try tx.SigHash(inputIndex: 0, scriptPubkey: script)
        print(sigHash.description)
        let string = Data(GMPInteger.bytes(sigHash)).hexEncodedString()
        let want = "27e0c5994dec7824e56dec6b2fcb342eb7cdb0d0957c2fce9882f715e85d81a6"
        XCTAssertEqual(string, want)



    }
    
    
    func testVerifyP2PKH() throws {
        let txString = "0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600"
        let scriptPubkey = "1976a914a802fc56c704ce87c42d7c92eb75e7896bdc41ae88ac"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        var input = InputStream(data: scriptPubkey.hexadecimal!)
        input.open()
        let script = try Script.init(input)
        input.close()
        let didPass = try tx.verifyInput(inputIndex: 0, scriptPubkey: script)
        XCTAssertTrue(didPass)
    }
    
    func testVerifyP2PKH2() throws {
        let txString = "010000000148dcc16482f5c835828020498ec1c35f48a578585721b5a77445a4ce93334d18000000006a4730440220636b9f822ea2f85e6375ecd066a49cc74c20ec4f7cf0485bebe6cc68da92d8ce022068ae17620b12d99353287d6224740b585ff89024370a3212b583fb454dce7c160121021f955d36390a38361530fb3724a835f4f504049492224a028fb0ab8c063511a7ffffffff0220960705000000001976a914d23541bd04c58a1265e78be912e63b2557fb439088aca0860100000000001976a91456d95dc3f2414a210efb7188d287bff487df96c688ac00000000"
        let scriptPubkey = "1976a914d23541bd04c58a1265e78be912e63b2557fb439088ac"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        var input = InputStream(data: scriptPubkey.hexadecimal!)
        input.open()
        let script = try Script.init(input)
        input.close()
        let didPass = try tx.verifyInput(inputIndex: 0, scriptPubkey: script)
        XCTAssertTrue(didPass)
    }
}
