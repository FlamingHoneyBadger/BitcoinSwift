//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import BigInt

class Point: NSObject {
    var a: FieldElement
    var b: FieldElement
    var x: FieldElement?
    var y: FieldElement?

    public override var description: String {
        if (self.x == nil) {
            return "Point(infinity)"
        }
        else {
            return "Point(\(String(describing: x?.number)), \(String(describing: y?.number)) a:\(a.number) b:\(b.number) FieldElement(\(a.prime))"
        }

    }

    init( x: FieldElement?, y: FieldElement?, a: FieldElement, b: FieldElement) throws {
        self.x = x
        self.y = y
        self.a = a
        self.b = b
        if ( x == nil  && y == nil){
            return
        }

        if( y!  ^^ 2 != (x!  ^^ 3 + (a * (x!) ) + b) ) {
            throw  pointError.pointNotOnCurve
        }

    }

    static func ==(left: Point, right: Point) -> Bool {
        if (((left.x ?? FieldElement.init(num: 0, prime: 1)) as FieldElement == (right.x ?? FieldElement.init(num: 0, prime: 1)) as FieldElement) &&
                ((left.y ?? FieldElement.init(num: 0, prime: 1)) as FieldElement == (right.y ?? FieldElement.init(num: 0, prime: 1)) as FieldElement) &&
                (left.a as FieldElement == right.a as FieldElement) &&
                (left.b as FieldElement == right.b )){
            return true
        }
        return false
    }

    static func !=(left: Point, right: Point) -> Bool {
        return !(left ==  right)
    }

    static func +(left: Point, right: Point) -> Point {
        precondition((left.a == right.a) && (left.b == right.b),"'Points \(left), \(right) are not on the same curve'")

        if (left.x == nil){
            return right
        }
        if(right.x == nil){
            return left
        }

        if(left.x == right.x && left.y != right.y){
            return try! Point.init(x: nil, y: nil, a: left.a, b: left.b)
        }


        if (left.x ?? FieldElement.init(num: 0, prime: 1) as FieldElement !=
            right.x ?? FieldElement.init(num: 0, prime: 1) as FieldElement){
            let s = (right.y! - left.y!) / (right.x! - left.x!)
            let x = s ^^ 2 - left.x! - right.x!
            let y = s * (left.x! - x) - left.y!
            return try! Point.init(x: x, y: y, a: left.a, b: left.b)
        }


        if(left == right && left.y == 0 * left.x!){
            return try! Point.init(x: nil, y: nil, a: left.a, b: left.b)
        }

        if(left == right){
            let s = (3 * left.x!^^2 + left.a) / (2 * left.y!)
            let x = s^^2 - 2 * left.x!
            let y = s * (left.x! - x) - left.y!
            return try! Point.init(x: x, y: y, a: left.a, b: left.b)
        }


        return try! Point.init(x: nil, y: nil, a: left.a, b: right.b)
    }



    static func *(coefficient: BigInt, point: Point) -> Point {
        var coef = coefficient
        var current = point
        var result = try! Point.init(x: nil, y: nil, a: point.a, b: point.b)

        while(coef != 0){
            if (coef & 1 != 0){
                result =  result + current
            }
            current = current + current
             coef = coef >> 1
        }
        return result
    }
}
enum pointError:Error {
    case pointNotOnCurve
}
