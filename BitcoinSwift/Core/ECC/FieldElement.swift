//
// Created by FlamingHoneyBadger on 5/15/21.
// Copyright (c) 2021 FlamingHoneyBadger. All rights reserved.
//

import Foundation

public class FieldElement : NSObject {
    var prime: Int
    var number: Int
    public override var description: String { return "FieldElement_\(prime)(\(number))" }

    init(prime:Int ,num:Int ) throws {
        if (num >= prime || num < 0){
            throw FieldElementError.numberNotInField
        }
        self.prime = prime
        self.number = num
    }

    static func ==(left: FieldElement, right: FieldElement) -> Bool {
    return false
    }

}

enum FieldElementError: Error {
    case numberNotInField

}
