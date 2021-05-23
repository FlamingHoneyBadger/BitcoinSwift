//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021 FlamingHoneyBadger. All rights reserved.
//

import Foundation
import BigInt

infix operator ^^:  BitwiseShiftPrecedence

class FieldElement : NSObject {
    var prime: BigInt
    var number: BigInt
    public override var description: String {
        return "FieldElement_\(prime)(\(number))"
    }

    init( num: BigInt, prime: BigInt)  {
        precondition(num < prime || num < 0,"'Num \(num) not in field range 0 to \(prime)'")
        self.prime = prime
        self.number = num
    }

    static func ==(left: FieldElement, right: FieldElement) -> Bool {
        if (left == nil || right == nil) {
            return false
        }
        return left.number == right.number && left.prime == right.prime
    }


    static func !=(left: FieldElement, right: FieldElement) -> Bool {
        return !(left == right)
    }

    static func +(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot add two numbers in different Fields")
        var num = (left.number + right.number)
        num = Helper.mod(num, left.prime)
        return  FieldElement.init(num: num, prime:left.prime)
    }

    static func -(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot subtract two numbers in different Fields")
        var num = (left.number - right.number)
        num =  Helper.mod(num,left.prime)
        return FieldElement.init(num: num, prime:left.prime)
    }

    static func *(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot multiply two numbers in different Fields")
        var num = (left.number * right.number)
        num = Helper.mod(num, left.prime)
        return FieldElement.init(num: num, prime:left.prime)
    }

    static func /(left: FieldElement, right: FieldElement)  -> FieldElement {
        precondition(left.prime == right.prime, "Cannot divide two numbers in different Fields")
        // use fermat's little theorem
        var num = (left.number * Helper.powMod(base: right.number, exponent: left.prime-2, modulo: left.prime))
        num = Helper.mod(num, left.prime)
        return FieldElement.init(num: num, prime:left.prime)
    }

    static func *(left: BigInt, right: FieldElement)  -> FieldElement {
        var num = (left * right.number)
        num = Helper.mod(num, right.prime)
        return FieldElement.init(num: num, prime:right.prime)
    }

    static func ^^(num: FieldElement, power: BigInt)  -> FieldElement {
        let n =  Helper.mod(power , (num.prime - 1))
        let number = Helper.powMod(base: num.number, exponent: n, modulo: num.prime)
        return FieldElement.init(num: number, prime:num.prime)

    }



}
