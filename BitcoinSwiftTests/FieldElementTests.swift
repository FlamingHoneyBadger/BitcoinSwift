//
//  BitcoinSwiftTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/15/21.
//

import XCTest
import SwiftGMP

@testable import BitcoinSwift


class FieldElementTests: XCTestCase {

    func testNotEqual() throws {
        let a =  FieldElement(num: GMPInteger(2), prime: GMPInteger(31))
        let b =  FieldElement(num: GMPInteger(2), prime: GMPInteger(31))
        let c =  FieldElement(num: GMPInteger(15), prime:GMPInteger( 31))
        XCTAssertTrue(a == b)
        XCTAssertTrue(a != c)
        XCTAssertFalse(a != b)

    }
    func testAdd() throws {
        var a = FieldElement(num: GMPInteger(2), prime: GMPInteger(31))
        var b = FieldElement(num: GMPInteger(15), prime: GMPInteger(31))
        var c =   a + b
        var test = FieldElement(num: GMPInteger(17), prime: GMPInteger(31))
        XCTAssertTrue( c == test)
        a =  FieldElement(num: GMPInteger(17), prime: GMPInteger(31))
        b =  FieldElement(num: GMPInteger(21), prime: GMPInteger(31))
        c =   a + b
        test =  FieldElement(num: GMPInteger(7), prime: GMPInteger(31))
        XCTAssertTrue( c == test)

    }

    func testSub() throws {
        var a =  FieldElement(num: GMPInteger(29), prime: GMPInteger(31))
        var b =  FieldElement(num: GMPInteger(4), prime: GMPInteger(31))
        var c =  a - b
        var test =  FieldElement(num: GMPInteger(25), prime: GMPInteger(31))
        XCTAssertTrue( c == test)
        a =  FieldElement(num: GMPInteger(15), prime: GMPInteger(31))
        b =  FieldElement(num: GMPInteger(30), prime: GMPInteger(31))
        c =  a - b
        test =  FieldElement(num: GMPInteger(16), prime: GMPInteger(31))
        XCTAssertTrue( c == test)
    }


    func testMul() throws {
        let a = FieldElement(num: GMPInteger(24), prime: GMPInteger(31))
        let b = FieldElement(num: GMPInteger(19), prime: GMPInteger(31))
        XCTAssertTrue((a*b) == FieldElement(num: GMPInteger(22), prime: GMPInteger(31)))
    }

    func testMulCof()throws {
        let a = FieldElement(num: GMPInteger(24), prime: GMPInteger(31))
        let b = GMPInteger(2)
        let c = b * a
        XCTAssertTrue(c == (a+a))

    }

//    func testpow() throws {
//        var a = FieldElement(num: GMPInteger(17), prime: GMPInteger(31))
//        let a1 = a^^3
//        XCTAssertTrue(a1 == FieldElement(num: GMPInteger(15), prime: GMPInteger((31)))
//        a = FieldElement(num: GMPInteger(5), prime: GMPInteger(31))
//        let b = FieldElement(num: GMPInteger(18), prime: GMPInteger(31))
//        let a2 = (a^^5 * b)
//        XCTAssertTrue( a2 == FieldElement(num:  GMPInteger(16), prime:  GMPInteger(31)) )
//    }
//
//    func testDiv() throws {
//        var a  = FieldElement(num:  GMPInteger(3), prime:  GMPInteger(31))
//        var b  = FieldElement(num:  GMPInteger(24), prime:  GMPInteger(31))
//        XCTAssertTrue((a/b) == FieldElement(num:  GMPInteger(4), prime:  GMPInteger(31)))
//        a  = FieldElement(num: 17, prime: 31)
//        XCTAssertTrue(a ^^ -3 == FieldElement(num: 29, prime: 31))
//        a = FieldElement(num: 4, prime: 31)
//        b = FieldElement(num: 11, prime: 31)
//        XCTAssertTrue((a ^^ -4 * b) == FieldElement(num: 13, prime: 31))
//    }
//    
    
    
    func test()  throws {
       // let Ns = "0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141"
        let N = GMPInteger("115792089237316195423570985008687907852837564279074904382605163141518161494337")
        print(N)
    }

}

