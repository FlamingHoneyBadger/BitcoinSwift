//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import XCTest
import SwiftGMP
@testable import BitcoinSwift

class PointTests: XCTestCase {

    func testOnCurve1() throws {

        let prime = GMPInteger( 223 )
        var valid_points:[(x: GMPInteger, y: GMPInteger)] = []
        valid_points.append((GMPInteger(192),GMPInteger(105)))
        valid_points.append((GMPInteger(17), GMPInteger(56)))
        valid_points.append((GMPInteger(1), GMPInteger(193)))

        let a = GMPInteger("0")
        let b = GMPInteger(7)

        for item in valid_points {
//            let p =  try Point(x:FieldElement(num: item.x, prime: prime) ,
//                           y: FieldElement(num: item.y, prime: prime),
//                           a: a, b: b)
            let p = Point(x: item.x, y: item.y, a: a, b: b, p: prime)
            print(p)
        }
    }
/*
    func testOnCurve2() throws {

        let prime = GMPInteger(223)
        var invalid_points:[(x: GMPInteger, y: GMPInteger)] = []

        invalid_points.append((200,119))
        invalid_points.append((42, 99))

        let a = FieldElement(num: 0, prime: prime)
        let b = FieldElement(num: 7, prime: prime)

        for item in invalid_points {
            try Point(x:FieldElement(num: item.x, prime: prime) ,
                    y: FieldElement(num: item.y, prime: prime),
                    a: a, b: b)
        }
    }
*/
    func testPointAdd1() throws {
        let prime = GMPInteger(223)
        let a = GMPInteger("0")
        let b = GMPInteger(7)

        let x1 = GMPInteger(192)
        let y1 = GMPInteger(105)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(17)
        let y2 = GMPInteger(56)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        let x3 = GMPInteger(170)
        let y3 = GMPInteger(142)
        let p3 = Point(x: x3, y: y3, a: a, b: b, p: prime)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue((p1 + p2) == p3)

    }

    func testPointAdd2() throws {
        let prime = GMPInteger(223)
        let a = GMPInteger()
        let b = GMPInteger(7)
        
        let x1 = GMPInteger(47)
        let y1 = GMPInteger(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(117)
        let y2 = GMPInteger(141)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        let x3 = GMPInteger(60)
        let y3 = GMPInteger(139)
        let p3 = Point(x: x3, y: y3, a: a, b: b, p: prime)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue(p1 + p2 == p3)

    }

    func testPointAdd3() throws {
        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)
        
        let x1 = GMPInteger(143)
        let y1 = GMPInteger(98)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(76)
        let y2 = GMPInteger(66)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        let x3 = GMPInteger(47)
        let y3 = GMPInteger(71)
        let p3 = Point(x: x3, y: y3, a: a, b: b, p: prime)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue(p1 + p2 == p3)
    }

    func testMul1() throws {
        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)

        let s = 2
        let x1 = GMPInteger(192)
        let y1 = GMPInteger(105)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(49)
        let y2 = GMPInteger(71)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(GMPInteger(s) * p1 == p2)
    }

    func testMul2() throws {

        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)
        let s = 2

        let x1 = GMPInteger(143)
        let y1 = GMPInteger(98)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(64)
        let y2 = GMPInteger(168)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        let r =  GMPInteger(s) * p1
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(GMPInteger(s) * p1 == p2)
    }

    func testMul3() throws {

        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)

        let s = 2
        let x1 = GMPInteger(47)
        let y1 = GMPInteger(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(36)
        let y2 = GMPInteger(111)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(GMPInteger(s) * p1 == p2)
    }

    func testMul4() throws {

        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)
        let s = 4

        let x1 = GMPInteger(47)
        let y1 = GMPInteger(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(194)
        let y2 = GMPInteger(51)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        let ps_1 =  (GMPInteger(s) * p1)
        XCTAssertTrue(ps_1 == p2)
    }

    func testMul5() throws {

        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)
        let s = 8

        let x1 = GMPInteger(47)
        let y1 = GMPInteger(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = GMPInteger(116)
        let y2 = GMPInteger(55)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(GMPInteger(s) * p1 == p2)
    }

    func testMul6() throws {

        let prime = GMPInteger(223)
        let a = GMPInteger(0)
        let b = GMPInteger(7)
        //      (21, 47, 71, None, None),
        let s = 21
 
        let x1 = GMPInteger(47)
        let y1 = GMPInteger(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)


        let p2 = Point.init(x: nil, y: nil, a: a, b: b, p: prime)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        let ps_1 =  (GMPInteger(s) * p1)
        XCTAssertTrue(ps_1 == p2)
    }

}







