//
//  RIPEMD-160-Tests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/22/21.
//

import Foundation
import XCTest
@testable import BitcoinSwift

class RIPEMD_160_tests : XCTestCase {
    
    func testRIPEMD_160_vec1(){
        let a =  RIPEMD160.hash(message: "")
        XCTAssertEqual( a.hexEncodedString(),"9c1185a5c5e9fc54612808977ee8f548b2258d31")
    }
    
    func testRIPEMD_160_vec2(){
        let a =  RIPEMD160.hash(message: "a")
        XCTAssertEqual( a.hexEncodedString(),"0bdc9d2d256b3ee9daae347be6f4dc835a467ffe")
    }
    
    func testRIPEMD_160_vec3(){
        let a =  RIPEMD160.hash(message: "abc")
        XCTAssertEqual( a.hexEncodedString(),"8eb208f7e05d987a9b044a8e98c6b087f15a0bfc")
    }
    
    func testRIPEMD_160_vec4(){
        let a =  RIPEMD160.hash(message: "message digest")
        XCTAssertEqual( a.hexEncodedString(),"5d0689ef49d2fae572b881b123a85ffa21595f36")
    }
    
    func testRIPEMD_160_vec5(){
        let a =  RIPEMD160.hash(message: "abcdefghijklmnopqrstuvwxyz")
        XCTAssertEqual( a.hexEncodedString(),"f71c27109c692c1b56bbdceb5b9d2865b3708dbc")
    }
    
    func testRIPEMD_160_vec6(){
        let a =  RIPEMD160.hash(message: "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
        XCTAssertEqual( a.hexEncodedString(),"12a053384a9c0c88e405a06c27dcf49ada62eb2b")
    }
    func testRIPEMD_160_vec7(){
        let a =  RIPEMD160.hash(message: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        XCTAssertEqual( a.hexEncodedString(),"b0e20b6e3116640286ed3a87a5713079b21f5189")
    }
    func testRIPEMD_160_vec8(){
        let a =  RIPEMD160.hash(message: "12345678901234567890123456789012345678901234567890123456789012345678901234567890")
        XCTAssertEqual( a.hexEncodedString(),"9b752e45573d4b39f4dbd3323cab82bf63326bfb")
    }
    func testRIPEMD_160_vec9(){
        let v = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        var tv = ""
        var i = 0
        while i < 1000 {
            tv += v
            i+=1
        }
        let a =  RIPEMD160.hash(message:tv )
        XCTAssertEqual( a.hexEncodedString(),"52783243c1697bdbe16d37f97f68f08325dc1528")
    }
    
    
}
