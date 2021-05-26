//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import XCTest
import BigInt
@testable import BitcoinSwift

class PointTests: XCTestCase {

    func testOnCurve1() throws {

        let prime = BigInt( 223 )
        var valid_points:[(x: BigInt, y: BigInt)] = []
        valid_points.append((192,105))
        valid_points.append((17, 56))
        valid_points.append((1, 193))

        let a = BigInt(0)
        let b = BigInt(7)

        for item in valid_points {
//            let p =  try Point(x:FieldElement(num: item.x, prime: prime) ,
//                           y: FieldElement(num: item.y, prime: prime),
//                           a: a, b: b)
            let p = Point(x: item.x, y: item.y, a: BigInt(a), b: BigInt(b), p: prime)
            print(p)
        }
    }
/*
    func testOnCurve2() throws {

        let prime = BigInt(223)
        var invalid_points:[(x: BigInt, y: BigInt)] = []

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
        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)

        let x1 = BigInt(192)
        let y1 = BigInt(105)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(17)
        let y2 = BigInt(56)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        let x3 = BigInt(170)
        let y3 = BigInt(142)
        let p3 = Point(x: x3, y: y3, a: a, b: b, p: prime)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue((p1 + p2) == p3)

    }

    func testPointAdd2() throws {
        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)
        
        let x1 = BigInt(47)
        let y1 = BigInt(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(117)
        let y2 = BigInt(141)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        let x3 = BigInt(60)
        let y3 = BigInt(139)
        let p3 = Point(x: x3, y: y3, a: a, b: b, p: prime)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue(p1 + p2 == p3)

    }

    func testPointAdd3() throws {
        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)
        
        let x1 = BigInt(143)
        let y1 = BigInt(98)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(76)
        let y2 = BigInt(66)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        let x3 = BigInt(47)
        let y3 = BigInt(71)
        let p3 = Point(x: x3, y: y3, a: a, b: b, p: prime)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue(p1 + p2 == p3)
    }

    func testMul1() throws {
        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)

        let s = 2
        let x1 = BigInt(192)
        let y1 = BigInt(105)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(49)
        let y2 = BigInt(71)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul2() throws {

        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)
        let s = 2

        let x1 = BigInt(143)
        let y1 = BigInt(98)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(64)
        let y2 = BigInt(168)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul3() throws {

        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)

        let s = 2
        let x1 = BigInt(47)
        let y1 = BigInt(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(36)
        let y2 = BigInt(111)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul4() throws {

        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)
        let s = 4

        let x1 = BigInt(47)
        let y1 = BigInt(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(194)
        let y2 = BigInt(51)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        let ps_1 =  (BigInt(s) * p1)
        XCTAssertTrue(ps_1 == p2)
    }

    func testMul5() throws {

        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)
        let s = 8

        let x1 = BigInt(47)
        let y1 = BigInt(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)

        let x2 = BigInt(116)
        let y2 = BigInt(55)
        let p2 = Point(x: x2, y: y2, a: a, b: b ,p: prime)
        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul6() throws {

        let prime = BigInt(223)
        let a = BigInt(0)
        let b = BigInt(7)
        //      (21, 47, 71, None, None),
        let s = 21
 
        let x1 = BigInt(47)
        let y1 = BigInt(71)
        let p1 = Point(x: x1, y: y1, a: a, b: b, p: prime)


        let p2 = Point.init(x: nil, y: nil, a: a, b: b, p: prime)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        let ps_1 =  (BigInt(s) * p1)
        XCTAssertTrue(ps_1 == p2)
    }

}







