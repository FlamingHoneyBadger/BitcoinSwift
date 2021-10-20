//
//  ECCTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/20/21.
//

import Foundation
import GMP
@testable import BitcoinSwift

import XCTest

class ECCTests : XCTestCase {
    
    func testVerify1() throws {
        let z = GMPInteger("106803335299316304368406718150407005727570940625608758663533317704082257612640")
        let r = GMPInteger("78047132305074547209667415378684003360790728528333174453334458954808711947157")
        let s = GMPInteger("2945795152904547855448158643091235482997756069461486099501216307557115896772")
        let point =  secp256k1Point.init(x: GMPInteger("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                            y: GMPInteger("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
        let sig = ECDSASignature.init(r: r, s: s)
        XCTAssertTrue(point.verify(z: z, sig: sig))
    }
    
    func testVerify2() throws {
        let z = GMPInteger("56099933801250147507530887846013995861658484709398205753844016085871945288253")
        let r = GMPInteger("423978563313610541820751014531939415111138679983830741516375588441135684140")
        let s = GMPInteger("90067678915080561991476742139334357116447229582337733602832701972810841451190")
        let point =  secp256k1Point.init(x: GMPInteger("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                            y: GMPInteger("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
        let sig = ECDSASignature.init(r: r, s: s)
        XCTAssertTrue( point.verify(z: z, sig: sig))
    }
    
    func testSecEncode1() throws {

        var coefficient = GMPInteger(999)
        coefficient = GMPInteger.pow(coefficient, 3)
        let uncompressed = "049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9"
        let compressed = "039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5"
        let p = coefficient * secp256k1Constants.G.point
        let point  = secp256k1Point(x: p.x,y: p.y)
        
        let myC =  point.SecBytes(isCompressed: true).hexEncodedString()
        let myUC =  point.SecBytes(isCompressed: false).hexEncodedString()

        XCTAssertEqual(compressed, myC)
        XCTAssertEqual(uncompressed, myUC)
    }
    
    func testSecEncode2() throws {

        let coefficient = GMPInteger(123)
        let uncompressed = "04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
        let compressed = "03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5"
        let p = coefficient * secp256k1Constants.G.point
        let point  = secp256k1Point(x: p.x,y: p.y)

        let myC =  point.SecBytes(isCompressed: true).hexEncodedString()
        let myUC =  point.SecBytes(isCompressed: false).hexEncodedString()

        XCTAssertEqual(compressed, myC)
        XCTAssertEqual(uncompressed, myUC)
    }
    
    func testSecEncode3() throws {

        let coefficient = GMPInteger(42424242)
        let uncompressed = "04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3"
        let compressed = "03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e"
        let p = coefficient * secp256k1Constants.G.point
        let point  = secp256k1Point(x: p.x,y: p.y)

        let myC =  point.SecBytes(isCompressed: true).hexEncodedString()
        let myUC =  point.SecBytes(isCompressed: false).hexEncodedString()

        XCTAssertEqual(compressed, myC)
        XCTAssertEqual(uncompressed, myUC)

    }
    
    func testSecParse1 () throws {
        
        let uncompressed = "049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9"
        let compressed = "039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5"
        let myUC = secp256k1Point.parse(data: uncompressed.hexadecimal!)
        let myC = secp256k1Point.parse(data: compressed.hexadecimal!)

        XCTAssertEqual(compressed, myC.SecBytes(isCompressed: true).hexEncodedString())
        XCTAssertEqual(uncompressed, myUC.SecBytes(isCompressed: false).hexEncodedString())
    }
    
    func testSecParse2() throws {
        
        let uncompressed = "04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
        let compressed = "03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5"
        let myUC = secp256k1Point.parse(data: uncompressed.hexadecimal!)
        let myC = secp256k1Point.parse(data: compressed.hexadecimal!)

        XCTAssertEqual(compressed, myC.SecBytes(isCompressed: true).hexEncodedString())
        XCTAssertEqual(uncompressed, myUC.SecBytes(isCompressed: false).hexEncodedString())
    }

    func testSecParse3() throws {
        
        let uncompressed = "04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3"
        let compressed = "03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e"
        let myUC = secp256k1Point.parse(data: uncompressed.hexadecimal!)
        let myC = secp256k1Point.parse(data: compressed.hexadecimal!)

        XCTAssertEqual(compressed, myC.SecBytes(isCompressed: true).hexEncodedString())
        XCTAssertEqual(uncompressed, myUC.SecBytes(isCompressed: false).hexEncodedString())
    }
    
    func testSigning() throws {
//        secret:
//        40739933752410060555609228973058042831504651302294666289131257978163635864942
//        Point:
//        S256Point(76ce0e83c312562842c7709b1ff1ab8413731b0136e6bf115703d8d043f767b7, 719b2919af947ce1200c82a8f6fa88479655edda8a28489848f9738b0f1a1068)
//        Z:
//        100714224755359001914014069612932105362547871363962210278001769511023688176367
//        3045022100d7764fb59c433f77ba9c50b77e116cea612de1b7379cf54d02604a42a1048636022018f2cbc1f70ebb63cc23fdf37b9587f590e0068d439938ec315c7402813fd5b0

        let key  = SecureBytes(bytes:GMPInteger.bytes(GMPInteger("40739933752410060555609228973058042831504651302294666289131257978163635864942")))
        let pk = try PrivateKey.init(key:key)
        print(pk.point.description)
        let z = GMPInteger("100714224755359001914014069612932105362547871363962210278001769511023688176367")
        let sig = pk.signWithECDSA(z:z)
        print("r:" + sig.r.description)
        print("s:" + sig.s.description)
        XCTAssertTrue(pk.point.verify(z: z, sig: sig))
        
        
    }
    
    
    func testDerBytes() throws {
        
       // 3006020101020102
        let sig = ECDSASignature.init(r: GMPInteger(1), s: GMPInteger(2))
        print(sig.DERBytes().hexEncodedString())
        XCTAssertEqual("3006020101020102", sig.DERBytes().hexEncodedString())
    }
    
    func testDerBytes1() throws {
        
        let sig = ECDSASignature.init(r: GMPInteger("83068191273585601115564015409649175006819469099404383897628358568700197346481"),
                                      s: GMPInteger("38842675350183364439118955731503053835886227788551698254571492815095328800241"))
        print(sig.DERBytes().hexEncodedString())
        XCTAssertEqual("3045022100b7a6ee1bfc10a4a29d0bad7f8a8757e346fc1330f5e6c465bf401d17b1c61cb1022055e02cd72e3868f11338843e184d4546f5c4e9c1705221607b20cc8c69d1fdf1", sig.DERBytes().hexEncodedString())
    }
    func testDerBytes2() throws {
        
        let sig = ECDSASignature.init(r: GMPInteger("87120559869154564334044386398598149165429382130626103720048019977536732935952"),
                                      s: GMPInteger("7569618491601465815862881259204006376169560180314110375896881192476579985944"))
        print(sig.DERBytes().hexEncodedString())
        XCTAssertEqual("3045022100c09c7d4d2e146041ffe363c5cde6d09d9686228721b193b776326c63d8343710022010bc4092ac8ecd373ea2b9626babb7683de92a025bb55604ff104e7b39abfa18", sig.DERBytes().hexEncodedString())
    }
    
    
    
   
    func testDetemenisticK() throws {

//        secret:
//        58719404139286711016959180277444754667373398415919558061107985415866847326494
//        Point:
//        S256Point(685b7dd4408213042e73cdc7eaeee87551d00d16edb700a251e2c54362ae148a, 88188a1d54f06bca535dd25b889cf4fe17bf3368b46e2ec2ef4ca84dd3533bad)
//        Z:
//        88204310995169350853996406688742836455588906325450995662934638734244926379609
//        304402201f7589409785bbc5a48fca612019185239976b136625c915faa02a68c1bcd1e4022007c5ba3374bdb35675e152477b6a729720d7249e4ad2c994939b483870694271
        let key  = SecureBytes(bytes:GMPInteger.bytes(GMPInteger("58719404139286711016959180277444754667373398415919558061107985415866847326494")))
        let pk = try PrivateKey.init(key:key)
        let z = GMPInteger("88204310995169350853996406688742836455588906325450995662934638734244926379609")
        let sig = pk.signWithECDSA(z:z)
        let hexSig = sig.DERBytes().hexEncodedString()

        XCTAssertEqual(hexSig, "304402201f7589409785bbc5a48fca612019185239976b136625c915faa02a68c1bcd1e4022007c5ba3374bdb35675e152477b6a729720d7249e4ad2c994939b483870694271")
        
    }
    

}

extension String {
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

