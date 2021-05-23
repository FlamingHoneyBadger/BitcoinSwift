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

        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        for item in valid_points {
            let p = try! Point.init(x:FieldElement.init(num: item.x, prime: prime) ,
                    y: FieldElement.init(num: item.y, prime: prime),
                    a: a, b: b)
            print(p)
        }
    }

    func testOnCurve2() throws {

        let prime = BigInt(223)
        var invalid_points:[(x: BigInt, y: BigInt)] = []

        invalid_points.append((200,119))
        invalid_points.append((42, 99))

        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        for item in invalid_points {
            XCTAssertThrowsError( try Point.init(x:FieldElement.init(num: item.x, prime: prime) ,
                    y: FieldElement.init(num: item.y, prime: prime),
                    a: a, b: b))
        }
    }

    func testPointAdd1() throws {
        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        let x1 = FieldElement.init(num: 192, prime: prime)
        let y1 = FieldElement.init(num: 105, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)
        let x2 = FieldElement.init(num: 17, prime: prime)
        let y2 = FieldElement.init(num: 56, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)
        let x3 = FieldElement.init(num: 170, prime: prime)
        let y3 = FieldElement.init(num: 142, prime: prime)
        let p3 = try Point.init(x: x3, y: y3, a: a, b: b)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue((p1 + p2) == p3)

    }

    func testPointAdd2() throws {
        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        let x1 = FieldElement.init(num: 47, prime: prime)
        let y1 = FieldElement.init(num: 71, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)
        let x2 = FieldElement.init(num: 117, prime: prime)
        let y2 = FieldElement.init(num: 141, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)
        let x3 = FieldElement.init(num: 60, prime: prime)
        let y3 = FieldElement.init(num: 139, prime: prime)
        let p3 = try Point.init(x: x3, y: y3, a: a, b: b)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue(p1 + p2 == p3)

    }

    func testPointAdd3() throws {
        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        let x1 = FieldElement.init(num: 143, prime: prime)
        let y1 = FieldElement.init(num: 98, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)
        let x2 = FieldElement.init(num: 76, prime: prime)
        let y2 = FieldElement.init(num: 66, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)
        let x3 = FieldElement.init(num: 47, prime: prime)
        let y3 = FieldElement.init(num: 71, prime: prime)
        let p3 = try Point.init(x: x3, y: y3, a: a, b: b)
        // check that p1 + p2 == p3
        let r = p1 + p2
        XCTAssertTrue(p1 + p2 == p3)
    }

    func testMul1() throws {
        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        let s = 2
        let x1 = FieldElement.init(num: 192, prime: prime)
        let y1 = FieldElement.init(num: 105, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)

        let x2 = FieldElement.init(num: 49, prime: prime)
        let y2 = FieldElement.init(num: 71, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul2() throws {

        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)
        let s = 2
        let x1 = FieldElement.init(num: 143, prime: prime)
        let y1 = FieldElement.init(num: 98, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)

        let x2 = FieldElement.init(num: 64, prime: prime)
        let y2 = FieldElement.init(num: 168, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul3() throws {

        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)

        let s = 2
        let x1 = FieldElement.init(num: 47, prime: prime)
        let y1 = FieldElement.init(num: 71, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)

        let x2 = FieldElement.init(num: 36, prime: prime)
        let y2 = FieldElement.init(num: 111, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul4() throws {

        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)
        let s = 4
        let x1 = FieldElement.init(num: 47, prime: prime)
        let y1 = FieldElement.init(num: 71, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)

        let x2 = FieldElement.init(num: 194, prime: prime)
        let y2 = FieldElement.init(num: 51, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        let ps_1 =  (BigInt(s) * p1)
        XCTAssertTrue(ps_1 == p2)
    }

    func testMul5() throws {

        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)
        let s = 8
        let x1 = FieldElement.init(num: 47, prime: prime)
        let y1 = FieldElement.init(num: 71, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)

        let x2 = FieldElement.init(num: 116, prime: prime)
        let y2 = FieldElement.init(num: 55, prime: prime)
        let p2 = try Point.init(x: x2, y: y2, a: a, b: b)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        XCTAssertTrue(BigInt(s) * p1 == p2)
    }

    func testMul6() throws {

        let prime = BigInt(223)
        let a = FieldElement.init(num: 0, prime: prime)
        let b = FieldElement.init(num: 7, prime: prime)
        //      (21, 47, 71, None, None),
        let s = 21
        let x1 = FieldElement.init(num: 47, prime: prime)
        let y1 = FieldElement.init(num: 71, prime: prime)
        let p1 = try Point.init(x: x1, y: y1, a: a, b: b)

        let p2 = try Point.init(x: nil, y: nil, a: a, b: b)

        // check that the product is equal to the expected point
        print("\(s) * \(p1) == \(p2)")
        let ps_1 =  (BigInt(s) * p1)
        XCTAssertTrue(ps_1 == p2)
    }

}







