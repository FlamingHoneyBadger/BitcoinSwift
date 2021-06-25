//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021 FlamingHoneyBadger. All rights reserved.
//

import Foundation
import SwiftGMP

infix operator ^^:  BitwiseShiftPrecedence

protocol Field  {
    var prime: GMPInteger { get set }
    var number: GMPInteger { get set }
    
}

struct FieldElement  : Field {
    var prime: GMPInteger
    var number: GMPInteger
    public var description: String {
        return "FieldElement_\(prime)(\(number))"
    }

    init( num: GMPInteger, prime: GMPInteger)  {
        precondition(num < prime || num < 0,"'Num \(num) not in field range 0 to \(prime)'")
        self.prime = prime
        self.number = num
    }
    
   
    
    
    public static func !=(left: FieldElement, right: FieldElement) -> Bool {
         return left.number != right.number || left.prime != right.prime
    }
    
    public static func +(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot add two numbers in different Fields")
        var num = (left.number + right.number)
        num = Helper.mod(num, left.prime)
        return  FieldElement(num: num, prime:left.prime)
    }
    
    
    public static func -(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot subtract two numbers in different Fields")
        var num = (left.number - right.number)
        num =  Helper.mod(num,left.prime)
        return FieldElement(num: num, prime:left.prime)
    }

    public static func *(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot multiply two numbers in different Fields")
        var num = (left.number * right.number)
        num = Helper.mod(num, left.prime)
        return FieldElement(num: num, prime:left.prime)
    }

    public static func /(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot divide two numbers in different Fields")
        // use fermat's little theorem
        var num = (left.number * GMPInteger.powMod(right.number, left.prime - 2, left.prime))
        num = num % left.prime
        return FieldElement(num: num, prime:left.prime)
    }

    public static func *(left: GMPInteger, right: FieldElement)  -> FieldElement {
        var num = (left * right.number)
        num = Helper.mod(num, right.prime)
        return FieldElement(num: num, prime:right.prime)
    }

    public static func ^^(num: FieldElement, power: GMPInteger)  -> FieldElement {
        let n =  power % (num.prime - 1)  // Helper.mod(power , (num.prime - 1))
        let number =  GMPInteger.powMod(num.number, n, num.prime)// Helper.powMod(base: num.number, exponent: n, modulo: num.prime)
        return FieldElement(num: number, prime:num.prime)

    }
}

extension FieldElement : Equatable {
    public static func ==(left: FieldElement, right: FieldElement) -> Bool {
        if (left == nil || right == nil) {
            return false
        }
        return left.number == right.number && left.prime == right.prime
    }
}



