//
//  WIFTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/31/21.
//



//pk = PrivateKey(0x0dba685b4511dbd3d368e5c4358a1277de9486447af7b3604a69b8d9d8b7889d)
//expected = '5HvLFPDVgFZRK9cd4C5jcWki5Skz6fmKqi1GQJf5ZoMofid2Dty'
//self.assertEqual(pk.wif(compressed=False, testnet=False), expected)
//pk = PrivateKey(0x1cca23de92fd1862fb5b76e5f4f50eb082165e5191e116c18ed1a6b24be6a53f)
//expected = 'cNYfWuhDpbNM1JWc3c6JTrtrFVxU4AGhUKgw5f93NP2QaBqmxKkg'
//self.assertEqual(pk.wif(compressed=True, testnet=True), expected)


import Foundation
import XCTest
import SwiftGMP
@testable import BitcoinSwift

class WIFTests : XCTestCase{
    
    func testWIF1() throws {
        let expected = "L5oLkpV3aqBJ4BgssVAsax1iRa77G5CVYnv9adQ6Z87te7TyUdSC"
        let s = GMPInteger("115792089237316194620101962879192770082288938495059262778356087116516711989248")
        let pk = PrivateKey.init(key: SecureBytes.init(bytes: GMPInteger.bytes(s)))
        XCTAssertEqual(expected, pk.wif(compressed: true, testnet: false) )
    }
    
    func testWIF2() throws {
        let expected = "93XfLeifX7Jx7n7ELGMAf1SUR6f9kgQs8Xke8WStMwUtrDucMzn"
        let s = GMPInteger("115792089237316192209694896490707356769345799983315358995051596442327459037184")
        let pk = PrivateKey.init(key: SecureBytes.init(bytes: GMPInteger.bytes(s)))
        XCTAssertEqual(expected, pk.wif(compressed: false, testnet: true) )
    }
    
    func testWIF3() throws {
        let expected = "5HvLFPDVgFZRK9cd4C5jcWki5Skz6fmKqi1GQJf5ZoMofid2Dty"
        let s =  GMPInteger("0dba685b4511dbd3d368e5c4358a1277de9486447af7b3604a69b8d9d8b7889d".hexadecimal!)
        let pk = PrivateKey.init(key: SecureBytes.init(bytes: GMPInteger.bytes(s)))
        XCTAssertEqual(expected, pk.wif(compressed: false, testnet: false) )
    }
    
    func testWIF4() throws {
        let expected = "cNYfWuhDpbNM1JWc3c6JTrtrFVxU4AGhUKgw5f93NP2QaBqmxKkg"
        let s = GMPInteger("1cca23de92fd1862fb5b76e5f4f50eb082165e5191e116c18ed1a6b24be6a53f".hexadecimal!)
        let pk = PrivateKey.init(key: SecureBytes.init(bytes: GMPInteger.bytes(s)))
        XCTAssertEqual(expected, pk.wif(compressed: true, testnet: true) )
    }
    
}
