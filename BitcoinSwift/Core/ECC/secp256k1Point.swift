//
//  scep256k1Point.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/19/21.
//

import Foundation
import BigInt
import Security

public class secp256k1Point  {
    var point :Point
    
    public  var description: String {
        if (self.point.x == nil) {
            return "Point(infinity)"
        }
        else {
            return "S256Point(\(String(describing: point.x)), \(String(describing: point.y)) a:\(point.a) b:\(point.b) FieldElement(\(point.p))"
        }

    }
    
    public init(x: BigInt?, y: BigInt?)  {
       if ( x == nil  && y == nil){
        self.point = Point(x: nil, y: nil, a: secp256k1Constants.A, b: secp256k1Constants.B, p: secp256k1Constants.P)
     
       }else{
        self.point  = Point(x: x, y: y, a: secp256k1Constants.A, b: secp256k1Constants.B, p: secp256k1Constants.P)
       }
    }
    
    
    public func verify(z: BigInt, sig: ECDSASignature)  -> Bool {
        let group = DispatchGroup()
        let G = secp256k1Constants.G.point
        // By Fermat's Little Theorem
        let s_inv = sig.s.power(secp256k1Constants.N - 2, modulus: secp256k1Constants.N)
        group.enter()
        var u : BigInt?
        var v : BigInt?

        var flag1=false ,flag2 = false
        var uG : Point?
        var vP : Point?

        DispatchQueue.global(qos: .userInitiated ).async{
            // u = z / s
            u = z * s_inv % secp256k1Constants.N
            uG = (u! * G)
            flag1 = true
            if(flag1 && flag2){
             group.leave()
            }
        }
        DispatchQueue.global(qos: .userInitiated ).async {
            // v = r / s
            v = sig.r * s_inv % secp256k1Constants.N
            vP = (v! * self.point)
            flag2 = true
            if(flag1 && flag2){
             group.leave()
            }
            
        }
        
        group.wait()
       
        // u*G + v*P(public point/key,this point)
        let result  = uG! + vP!
        return result.x == sig.r
    }
    
     static func parse(data: Data)  -> secp256k1Point {
        
        let bytes  = data.bytes
        let type =  bytes[0]
        if(type == 4){
            let x = BigInt(BigUInt(Data(bytes[1..<33])))
            let y = BigInt(BigUInt(Data(bytes[33..<65])))
            return  secp256k1Point.init(x: x, y: y)
        }
        let x : FieldElement = secp256k1Field(num: BigInt(BigUInt(Data(bytes[1..<33])))).element

        let alpha  = (x ^^ 3)  + secp256k1Field.init(num: secp256k1Constants.B).element
        let alphaS256 = secp256k1Field.init(num: alpha.number)
        let beta = alphaS256.sqrt()

        var evenBeta : secp256k1Field
        var oddBeta : secp256k1Field
        
        if (beta.element.number.modulus(2) == 0 ){
             evenBeta = beta
            oddBeta = secp256k1Field(num: secp256k1Constants.P - beta.element.number)
        }else{
            evenBeta = secp256k1Field(num: secp256k1Constants.P - beta.element.number)
             oddBeta = beta
        }
        
        if(type == 3){ //odd
            return  secp256k1Point.init(x: x.number, y: oddBeta.element.number)

        }else{ //even
            return  secp256k1Point.init(x: x.number, y: evenBeta.element.number)
        }
    }
    
    func p2pkhAddress(isCompressed: Bool, testnet: Bool) -> String {
        let h160 = self.hash160(isCompressed: isCompressed)
        var address = Data()
        if (testnet){
            address.append(UInt8(0x6f))
        }else{
            address.append(UInt8(0x00))
        }
        
        address.append(h160)
        
        return address.base58EncodeWithCheckSum()
    }
        
    
    func SecBytes(isCompressed: Bool) -> Data {
        
        var data = Data()
        if(isCompressed){
            if(self.point.y?.modulus(2) == 0){
                data.append(UInt8(0x02))
                data.append(self.point.x?.magnitude.serialize() ?? Data())
            }else{
                data = Data()
                data.append(UInt8(0x03))
                data.append(self.point.x?.magnitude.serialize() ?? Data())
            }
        }else{
            data.append(0x04)
            data.append(self.point.x?.magnitude.serialize() ?? Data())
            data.append(self.point.y?.magnitude.serialize() ?? Data())

        }
        return data
        
    }

    func hash160(isCompressed: Bool) -> Data {
        return Helper.hash160(data: self.SecBytes(isCompressed: isCompressed))
    }

    
        
}

    
   /*
     static func *(coefficient: BigInt, point: secp256k1Point)  -> secp256k1Point  {
        var coef = coefficient.modulus(secp256k1Constants.N)
        var current = point
        var result : secp256k1Point = try! secp256k1Point.init(x: nil, y: nil)

        while(coef  != 0){
            if (coef & 1 != 0){
                result =   result + current
            }
            current =   current + current
            coef = coef >> 1
        }

        return result
        
    }
    
    
    
     init(x: BigInt?, y: BigInt?) throws {
        if ( x == nil  && y == nil){
           
            try super.init(x: nil, y: nil, a: FieldElement.init(num: secp256k1Constants.A, prime: secp256k1Constants.P), b: FieldElement.init(num:secp256k1Constants.B, prime: secp256k1Constants.P))
        }else{
           try  super.init(x: FieldElement.init(num: x!, prime: secp256k1Constants.P), y: FieldElement.init(num: y!, prime: secp256k1Constants.P), a: FieldElement.init(num: secp256k1Constants.A, prime: secp256k1Constants.P), b: FieldElement.init(num: secp256k1Constants.B, prime: secp256k1Constants.P))
        }
    }
    

    static func +(left: secp256k1Point, right: secp256k1Point) -> secp256k1Point {
        precondition((left.a == right.a) && (left.b == right.b),"'Points \(left), \(right) are not on the same curve'")

        if (left.x == nil){
            return right
        }
        if(right.x == nil){
            return left
        }

        if(left.x! == right.x! && left.y! != right.y!){
            return try! secp256k1Point.init(x: nil, y: nil)
        }


        if (left.x ?? FieldElement.init(num: 0, prime: 1) as FieldElement !=
            right.x ?? FieldElement.init(num: 0, prime: 1) as FieldElement){
            let s = (right.y! - left.y!) / (right.x! - left.x!)
            let x = s ^^ 2 - left.x! - right.x!
            let y = s * (left.x! - x) - left.y!
            return try! secp256k1Point.init(x: x.number, y: y.number)
        }


        if(left == right && left.y == 0 * left.x!){
            return try! secp256k1Point.init(x: nil, y: nil)
        }

        if(left == right){
            let s = (3 * left.x!^^2 + left.a) / (2 * left.y!)
            let x = s^^2 - 2 * left.x!
            let y = s * (left.x! - x) - left.y!
            return try! secp256k1Point.init(x: x.number, y: y.number)
        }


        return try! secp256k1Point.init(x: nil, y: nil)
    }
    
    
    
    static func parse(data: Data) throws -> secp256k1Point{
        
        let bytes  = data.bytes
        let type =  bytes[0]
        if(type == 4){
            let x = BigInt(BigUInt(Data(bytes[1..<33])))
            let y = BigInt(BigUInt(Data(bytes[33..<65])))
            return try secp256k1Point.init(x: x, y: y)
        }
        let x : secp256k1Field = secp256k1Field(num: BigInt(BigUInt(Data(bytes[1..<33]))))

        let alpha  = (x ^^ 3)  + secp256k1Field.init(num: secp256k1Constants.B)
        let alphaS256 = secp256k1Field.init(num: alpha.number)
        let beta = alphaS256.sqrt()

        var evenBeta : secp256k1Field
        var oddBeta : secp256k1Field
        
        if (beta.number.modulus(2) == 0 ){
             evenBeta = beta
             oddBeta = secp256k1Field(num: secp256k1Constants.P - beta.number)
        }else{
             evenBeta = secp256k1Field(num: secp256k1Constants.P - beta.number)
             oddBeta = beta
        }
        
        if(type == 3){ //odd
            return try secp256k1Point.init(x: x.number, y: oddBeta.number)

        }else{ //even
            return try secp256k1Point.init(x: x.number, y: evenBeta.number)
        }
    }
    
    
    func SecBytes(isCompressed: Bool) -> Data {
        
        var data = Data()
        if(isCompressed){
            if(self.y?.number.modulus(2) == 0){
                data.append(UInt8(0x02))
                data.append(self.x?.number.magnitude.serialize() ?? Data())
            }else{
                data = Data()
                data.append(UInt8(0x03))
                data.append(self.x?.number.magnitude.serialize() ?? Data())
            }
        }else{
            data.append(0x04)
            data.append(self.x?.number.magnitude.serialize() ?? Data())
            data.append(self.y?.number.magnitude.serialize() ?? Data())

        }
        return data
        
    }
    
    func hash160(isCompressed: Bool) -> Data {
        return Helper.hash160(data: self.SecBytes(isCompressed: isCompressed))
    }
    
    func p2pkhAddress(isCompressed: Bool, testnet: Bool) -> String {
        let h160 = self.hash160(isCompressed: isCompressed)
        var address = Data()
        if (testnet){
            address.append(UInt8(0x6f))
        }else{
            address.append(UInt8(0x00))
        }
        
        address.append(h160)
        
        return address.base58EncodeWithCheckSum()
    }
    
    */
    


