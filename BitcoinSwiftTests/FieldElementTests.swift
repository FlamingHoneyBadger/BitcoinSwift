//
//  BitcoinSwiftTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/15/21.
//

import XCTest
import BigInt

@testable import BitcoinSwift


class FieldElementTests: XCTestCase {

    func testNotEqual() throws {
        let a =  FieldElement.init(num: 2, prime: 31)
        let b =  FieldElement.init(num: 2, prime: 31)
        let c =  FieldElement.init(num: 15, prime: 31)
        XCTAssertTrue(a == b)
        XCTAssertTrue(a != c)
        XCTAssertFalse(a != b)

    }
    func testAdd() throws {
        var a = FieldElement.init(num: 2, prime: 31)
        var b = FieldElement.init(num: 15, prime: 31)
        var c =   a + b
        var test = FieldElement.init(num: 17, prime: 31)
        XCTAssertTrue( c == test)
        a =  FieldElement.init(num: 17, prime: 31)
        b =  FieldElement.init(num: 21, prime: 31)
        c =   a + b
        test =  FieldElement.init(num: 7, prime: 31)
        XCTAssertTrue( c == test)

    }

    func testSub() throws {
        var a =  FieldElement.init(num: 29, prime: 31)
        var b =  FieldElement.init(num: 4, prime: 31)
        var c =  a - b
        var test =  FieldElement.init(num: 25, prime: 31)
        XCTAssertTrue( c == test)
        a =  FieldElement.init(num: 15, prime: 31)
        b =  FieldElement.init(num: 30, prime: 31)
        c =  a - b
        test =  FieldElement.init(num: 16, prime: 31)
        XCTAssertTrue( c == test)
    }


    func testMul() throws {
        let a = FieldElement.init(num: 24, prime: 31)
        let b = FieldElement.init(num: 19, prime: 31)
        XCTAssertTrue((a*b) == FieldElement.init(num: 22, prime: 31))
    }

    func testMulCof()throws {
        let a = FieldElement.init(num: 24, prime: 31)
        let b = BigInt(2)
        let c = b * a
        XCTAssertTrue(c == (a+a))

    }

    func testpow() throws {
        var a = FieldElement.init(num: BigInt(17), prime: BigInt(31))
        let a1 = a^^3
        XCTAssertTrue(a1 == FieldElement.init(num: BigInt(15), prime: BigInt(31)))
        a = FieldElement.init(num: 5, prime: 31)
        let b = FieldElement.init(num: 18, prime: 31)
        let a2 = (a^^5 * b)
        XCTAssertTrue( a2 == FieldElement.init(num: 16, prime: 31) )
    }

    func testDiv() throws {
        var a  = FieldElement.init(num: 3, prime: 31)
        var b  = FieldElement.init(num: 24, prime: 31)
        XCTAssertTrue((a/b) == FieldElement.init(num: 4, prime: 31))
        a  = FieldElement.init(num: 17, prime: 31)
        XCTAssertTrue(a ^^ -3 == FieldElement.init(num: 29, prime: 31))
        a = FieldElement.init(num: 4, prime: 31)
        b = FieldElement.init(num: 11, prime: 31)
        XCTAssertTrue((a ^^ -4 * b) == FieldElement.init(num: 13, prime: 31))
    }
    
    
    
    func test()  throws {
       // let Ns = "0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141"
        let N = BigInt("115792089237316195423570985008687907852837564279074904382605163141518161494337")
        print(N)
    }

}
