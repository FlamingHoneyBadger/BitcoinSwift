//
//  scep256k1Tests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/19/21.
//
import XCTest
import Foundation
import BigInt

@testable import BitcoinSwift

class Scep256k1Tests: XCTestCase {
    
        func testNG() throws {
             let N = BigInt("115792089237316195423570985008687907852837564279074904382605163141518161494337")


            let G = secp256k1Constants.G
            
            let point = N * G.point
            print(point.description)
            XCTAssertTrue(point.description == "Point(infinity)")
            


        }


        func testKnownPointsOnCurve() throws {
            let G : secp256k1Point = secp256k1Constants.G

            var item:(secret: BigInt, point: secp256k1Point)
            item  = (7, secp256k1Point(
                                x: BigInt("41948375291644419605210209193538855353224492619856392092318293986323063962044"),
                                y: BigInt("48361766907851246668144012348516735800090617714386977531302791340517493990618")))
           
            
                let a = item.secret * G.point
                print(item.point.point)
                print(a)
                XCTAssertTrue(a ==  item.point.point)
            
        }
    
    func testKnownPointsOnCurve1() throws {
        let G : secp256k1Point = secp256k1Constants.G

        var item:(secret: BigInt, point: secp256k1Point)

     
        item  = ( 1485, secp256k1Point.init(
                            x: BigInt("91144748097329341227315146716405895133044962575665947613151200288251569549274"),
                            y: BigInt("55440085219269127825789759728109305451504918753795093767574238082182444752725")))
     
        let a = item.secret * G.point
        print(item.point)
        print(a)
        XCTAssertTrue(a ==  item.point.point)
        
    }
    
    func testKnownPointsOnCurve2() throws {
        let G : secp256k1Point = secp256k1Constants.G

        var item:(secret: BigInt, point: secp256k1Point)
        let a1 = BigInt("340282366920938463463374607431768211456")
        try item  = (a1, secp256k1Point.init(
                            x: BigInt("64865771952738249789114440545196421582918768733599534045195125031385885360346"),
                            y: BigInt("46211216742671250426576585530459394900178019437443360579906162037052661563266")))

        
        
            let a = item.secret * G.point
            print(item.point)
            print(a)
            XCTAssertTrue(a ==  item.point.point)
        
    }
    
    
    func testKnownPointsOnCurve3() throws {
        let G : secp256k1Point = secp256k1Constants.G

        var item:(secret: BigInt, point: secp256k1Point)

        let b = BigInt("1766847064778384329583297500742918515827483896875618958121606203440103424")
        item  = ((b, secp256k1Point(
                            x: BigInt("67606631551526079174363160834905769336240182401619533769043587988551063851286"),
                            y: BigInt("7556117524685686037096665667879267882143292133281453141941949923550388736083"))))
        
        
            let a = item.secret * G.point
            print(item.point.point)
            print(a)
            XCTAssertTrue(a ==  item.point.point)
        

    }



    
    
}

