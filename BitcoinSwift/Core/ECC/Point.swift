//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation
import GMP




public struct   Point {
    public var a: GMPInteger
    public var b: GMPInteger
    public var x: GMPInteger?
    public var y: GMPInteger?
    public var p: GMPInteger
    
    public  var description: String {
        if (self.x == nil) {
            return "Point(infinity)"
        }
        else {
            return "Point(\(String(describing: x)), \(String(describing: y)) a:\(a) b:\(b) FieldElement(\(p))"
        }

    }
    
    
    internal mutating func equal(left: Point, right: Point) -> Bool {
            return true
        
    }

    init( x: GMPInteger?, y: GMPInteger?, a: GMPInteger, b: GMPInteger ,p: GMPInteger)  {
        
        self.x = x
        self.y = y
        self.a = a
        self.b = b
        self.p = p
        
        if ( x == nil  && y == nil){
            return
        }
//
//        if( y!  ^^ 2 != (x!  ^^ 3 + (a * (x!) ) + b) ) {
//            precondition(false ,"Point is not on curve!")
//        }
        
        // y^2 != x^3+(a*x+b)
        if( GMPInteger.pow(y!,2) % p != (GMPInteger.pow(x!,3) + (a * (x!) ) + b) % p) {
            precondition(false ,"Point is not on curve!")
        }


    }

}
    extension Point {
   

    static func +(left: Point, right: Point) -> Point {
        precondition((left.a == right.a) && (left.b == right.b),"'Points \(left), \(right) are not on the same curve'")

        if (left.x == nil){
            return right
        }
        
        if(right.x == nil){
            return left
        }

       
        if(left.x! == right.x! && left.y! != right.y!){
            return Point(x: nil, y: nil, a: left.a, b: left.b,p: left.p)
        }
        var lam = GMPInteger()
        if(left == right){
            //lam = (3 * x(P1) * x(P1) * pow(2 * y(P1), p - 2, p)) % p
            lam =  ( GMPInteger(3) * left.x! * left.x! * GMPInteger.powMod(GMPInteger(2) * left.y!, left.p - 2, left.p)) % left.p
            //lam = (3 * left.x! * left.x! * Helper.powMod(base: 2 * left.y! , exponent: left.p - 2 , modulo: left.p)).modulus(left.p)
        }else{
            //lam = ((y(P2) - y(P1)) * pow(x(P2) - x(P1), p - 2, p)) % p
           // lam = ((right.y! - left.y!) * Helper.powMod(base: right.x! - left.x!, exponent: left.p - 2, modulo: left.p)).modulus(left.p)
            lam = ((right.y! - left.y!) * GMPInteger.powMod(right.x! - left.x!, left.p - 2, left.p) )
        }
        // x3 = (lam * lam - x(P1) - x(P2)) % p
        let x3 = (lam * lam - left.x! - right.x!) % left.p
        // (lam * (x(P1) - x3) - y(P1)) % p
        let y3 = (lam * (left.x! - x3) - left.y!) % left.p
        
        return Point(x: x3, y: y3, a: left.a, b: left.b, p: left.p)
       
    }
    
//    static func +=(left: inout Point, right: Point) {
//        precondition((left.a == right.a) && (left.b == right.b),"'Points \(left), \(right) are not on the same curve'")
//
//        if (left.x == nil){
//            left = right
//            return
//        }
//        if(right.x == nil){
//           return
//        }
//
//        if(left.x! == right.x! && left.y! != right.y!){
//            left = Point(x: nil, y: nil, a: left.a, b: left.b)
//            return
//        }
//
//
//        if (left.x  != right.x ){
//            let s = (right.y! - left.y!) / (right.x! - left.x!)
//            let x = s ^^ 2 - left.x! - right.x!
//            let y = s * (left.x! - x) - left.y!
//            left =  Point.init(x: x, y: y, a: left.a, b: left.b)
//            return
//        }
//
//
//        if(left == right && left.y! == 0 * left.x!){
//            left = Point.init(x: nil, y: nil, a: left.a, b: left.b)
//            return
//        }
//
//        if(left == right){
//            //  lam = (3 * x(P1) * x(P1) * pow(2 * y(P1), p - 2, p)) % p
//            let s = (3 * left.x!^^2 + left.a) / (2 * left.y!)
//            let x = s^^2 - 2 * left.x!
//            let y = s * (left.x! - x) - left.y!
//            left =  Point(x: x, y: y, a: left.a, b: left.b)
//            return
//        }

    



    static func *(coefficient: GMPInteger, point: Point) -> Point {
        var coef = coefficient
        var current = point
        var result = Point(x: nil, y: nil, a: point.a, b: point.b, p: point.p)

//        while coef:
//            if coef & 1:
//                result += current
//            current += current
//            coef >>= 1
        while (coef != 0) {
            if((coef & GMPInteger(1)) != 0){
                result = result + current
            }
            current = current + current
            coef  = coef >> 1

        }

        return result
    }
 
}

extension Point : Equatable {
    public static func ==(left: Point, right: Point) -> Bool {

        if (((left.x)  == (right.x) ) &&
                ((left.y) == (right.y ) ) &&
                (left.a == right.a ) &&
                (left.b  == right.b )){
            return true
        }
        return false
    }
    
    static func !=(left: Point, right: Point) -> Bool {
        return !(left == right)
    }
}

