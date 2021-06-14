//
//  scep256k1Point.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/19/21.
//

import Foundation
import GMP
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
    
    public init(x: GMPInteger?, y: GMPInteger?)  {
       if ( x == nil  && y == nil){
        self.point = Point(x: nil, y: nil, a: secp256k1Constants.A, b: secp256k1Constants.B, p: secp256k1Constants.P)
     
       }else{
        self.point  = Point(x: x, y: y, a: secp256k1Constants.A, b: secp256k1Constants.B, p: secp256k1Constants.P)
       }
    }
    
    public init(p: Point)  {
        self.point = p
    }
    
    public func verify(z: GMPInteger, sig: ECDSASignature)  -> Bool {
        let group = DispatchGroup()
        let G = secp256k1Constants.G.point
        // By Fermat's Little Theorem
        let s_inv = GMPInteger.powMod(sig.s,secp256k1Constants.N - 2, secp256k1Constants.N)
        group.enter()
        var u : GMPInteger?
        var v : GMPInteger?

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
            let x = GMPInteger(Data(bytes[1..<33]))
            let y = GMPInteger(Data(bytes[33..<65]))
            return secp256k1Point.init(x: x, y: y)
        }
        let x : secp256k1Field = secp256k1Field(num: GMPInteger(Data(bytes[1..<33])))

        let alpha  = (x.element ^^ GMPInteger(3))  + secp256k1Field.init(num: secp256k1Constants.B).element
        let alphaS256 = secp256k1Field.init(num: alpha.number)
        let beta = alphaS256.sqrt()

        var evenBeta : secp256k1Field
        var oddBeta : secp256k1Field
        
        if (beta.element.number % 2 == 0 ){
             evenBeta = beta
            oddBeta = secp256k1Field(num: secp256k1Constants.P - beta.element.number)
        }else{
            evenBeta = secp256k1Field(num: secp256k1Constants.P - beta.element.number)
             oddBeta = beta
        }
        
        if(type == 3){ //odd
            return secp256k1Point.init(x: x.element.number, y: oddBeta.element.number)

        }else{ //even
            return secp256k1Point.init(x: x.element.number, y: evenBeta.element.number)
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
            if(self.point.y! % 2 == 0){
                data.append(UInt8(0x02))
                data.append(Data(GMPInteger.bytes(self.point.x!)))
            }else{
                data = Data()
                data.append(UInt8(0x03))
                data.append(Data(GMPInteger.bytes(self.point.x!)))
            }
        }else{
            data.append(0x04)
            data.append(Data(GMPInteger.bytes(self.point.x!)))
            data.append(Data(GMPInteger.bytes(self.point.y!)))

        }
        return data
        
    }

    func hash160(isCompressed: Bool) -> Data {
        return Helper.hash160(data: self.SecBytes(isCompressed: isCompressed))
    }

    
        
}
