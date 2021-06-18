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
    
    func testVerifyP2SH() throws {
        let txString = "0100000001868278ed6ddfb6c1ed3ad5f8181eb0c7a385aa0836f01d5e4789e6bd304d87221a000000db00483045022100dc92655fe37036f47756db8102e0d7d5e28b3beb83a8fef4f5dc0559bddfb94e02205a36d4e4e6c7fcd16658c50783e00c341609977aed3ad00937bf4ee942a8993701483045022100da6bee3c93766232079a01639d07fa869598749729ae323eab8eef53577d611b02207bef15429dcadce2121ea07f233115c6f09034c0be68db99980b9a6c5e75402201475221022626e955ea6ea6d98850c994f9107b036b1334f18ca8830bfff1295d21cfdb702103b287eaf122eea69030a0e9feed096bed8045c8b98bec453e1ffac7fbdbd4bb7152aeffffffff04d3b11400000000001976a914904a49878c0adfc3aa05de7afad2cc15f483a56a88ac7f400900000000001976a914418327e3f3dda4cf5b9089325a4b95abdfa0334088ac722c0c00000000001976a914ba35042cfe9fc66fd35ac2224eebdafd1028ad2788acdc4ace020000000017a91474d691da1574e6b3c192ecfb52cc8984ee7b6c568700000000"
        let scriptPubkey = "17a91474d691da1574e6b3c192ecfb52cc8984ee7b6c5687"
        let data =  txString.hexadecimal!
        let tx = try Tx.init(InputStream(data: data))
        let script = try Script.init(scriptPubkey.hexadecimal!)
        let didPass = try tx.verifyInput(inputIndex: 0, scriptPubkey: script)
        XCTAssertTrue(didPass)
    }
    
    
    func testSignInput() throws {
        let rawtx = "010000000199a24308080ab26e6fb65c4eccfadf76749bb5bfa8cb08f291320b3c21e56f0d0d00000000ffffffff02408af701000000001976a914d52ad7ca9b3d096a38e752c2018e6fbc40cdf26f88ac80969800000000001976a914507b27411ccf7f16f10297de6cef3f291623eddf88ac00000000"
        let wantedTx = "010000000199a24308080ab26e6fb65c4eccfadf76749bb5bfa8cb08f291320b3c21e56f0d0d0000006b4830450221008ed46aa2cf12d6d81065bfabe903670165b538f65ee9a3385e6327d80c66d3b502203124f804410527497329ec4715e18558082d489b218677bd029e7fa306a72236012103935581e52c354cd2f484fe8ed83af7a3097005b2f9c60bff71d35bd795f54b67ffffffff02408af701000000001976a914d52ad7ca9b3d096a38e752c2018e6fbc40cdf26f88ac80969800000000001976a914507b27411ccf7f16f10297de6cef3f291623eddf88ac00000000"
        let scriptPubkey = "1976a914d52ad7ca9b3d096a38e752c2018e6fbc40cdf26f88ac"
        let script = try Script.init(scriptPubkey.hexadecimal!)
        let key  = SecureBytes(bytes:GMPInteger.bytes(GMPInteger("8675309")))
        let pk = PrivateKey.init(key:key)
        let stream = InputStream.init(data: rawtx.hexadecimal!)
        stream.open()
        let tx = try Tx.init(stream, true)
        stream.close()
        print(pk.point.description)
        XCTAssertTrue(try tx.SignInputP2PKHorP2SH(inputIndex: 0, privateKey: pk, scriptPubkey: script))
        XCTAssertEqual(try tx.Serialize().hexEncodedString(), wantedTx)
    }
    
    func testP2SH1of1Sign() throws {
        let rawtx = "0100000001860334704ebf0ffde9ecad210d7e6538806a17bc6de2c2892fbab3a07bc0af56000000006a47304402206bdd3064d95b9f8f0b98bdca94b561b8307af888874758eea8b69fb6eb5a43f70220022be9e1eef220e44214d822c86fbfa05cbf5a73af2821b34234c53e6cbc562b012103c92ca96a054f7fc0ba18cb811a812d0986a2027f41beb8e6ef7c01cca037ce27ffffffff011b2701000000000017a914b323cd74b873366a9704d6f012eeaa1b410fade38700000000"
        let wanted = "01000000019712762d820ccfec68bb57cba2f554cb7fb54d3e1a08fca8508f8211c5c8990a000000007000483045022100a95757c4da439bc36339969627541112239ec1cd28b89b838211e12eb43b74b1022007c12380b1619736ab2e259d6249dcc8fb8f91c2f6a9307e9aa920b504f375ee0125512103c92ca96a054f7fc0ba18cb811a812d0986a2027f41beb8e6ef7c01cca037ce2751aeffffffff014f2601000000000017a914efc674ca71bada28af995f365926cc7923631d328700000000"
        let address = "2NF73E7PMwxUHJKcEcgU6ENdotPZL23TT1H"
        let h160 = Data(address.decodeBase58Address())
        print(h160.hexEncodedString())
    }
}
