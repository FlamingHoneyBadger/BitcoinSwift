//
//  ECCTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 5/20/21.
//

import Foundation
import BigInt
@testable import BitcoinSwift

import XCTest

class ECCTests : XCTestCase {
    
    func testVerify1() throws {
        let z = BigInt("106803335299316304368406718150407005727570940625608758663533317704082257612640")
        let r = BigInt("78047132305074547209667415378684003360790728528333174453334458954808711947157")
        let s = BigInt("2945795152904547855448158643091235482997756069461486099501216307557115896772")
        let point =  secp256k1Point.init(x: BigInt("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                            y: BigInt("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
        let sig = ECDSASignature.init(r: r, s: s)

        XCTAssertTrue( point.verify(z: z, sig: sig))
        print(sig.DERBytes().hexEncodedString())
    }
    
    func testVerify2() throws {
        let z = BigInt("56099933801250147507530887846013995861658484709398205753844016085871945288253")
        let r = BigInt("423978563313610541820751014531939415111138679983830741516375588441135684140")
        let s = BigInt("90067678915080561991476742139334357116447229582337733602832701972810841451190")
        let point =  secp256k1Point.init(x: BigInt("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                            y: BigInt("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
        let sig = ECDSASignature.init(r: r, s: s)
        XCTAssertTrue( point.verify(z: z, sig: sig))

        
    }
    
    func testSecEncode1() throws {

        var coefficient = BigInt(999)
        coefficient = coefficient.power(3)
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

        let coefficient = BigInt(123)
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

        let coefficient = BigInt(42424242)
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
        let myUC = try secp256k1Point.parse(data: Data.init(hex: uncompressed))
        let myC = try secp256k1Point.parse(data: Data.init(hex: compressed))
        
        XCTAssertEqual(compressed, myC.SecBytes(isCompressed: true).hexEncodedString())
        XCTAssertEqual(uncompressed, myUC.SecBytes(isCompressed: false).hexEncodedString())
    }
    
    func testSecParse2() throws {
        
        let uncompressed = "04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
        let compressed = "03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5"
        let myUC = try secp256k1Point.parse(data: Data.init(hex: uncompressed))
        let myC = try secp256k1Point.parse(data: Data.init(hex: compressed))
        
        XCTAssertEqual(compressed, myC.SecBytes(isCompressed: true).hexEncodedString())
        XCTAssertEqual(uncompressed, myUC.SecBytes(isCompressed: false).hexEncodedString())
    }

    func testSecParse3() throws {
        
        let uncompressed = "04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3"
        let compressed = "03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e"
        let myUC = try secp256k1Point.parse(data: Data.init(hex: uncompressed))
        let myC = try secp256k1Point.parse(data: Data.init(hex: compressed))
        
        XCTAssertEqual(compressed, myC.SecBytes(isCompressed: true).hexEncodedString())
        XCTAssertEqual(uncompressed, myUC.SecBytes(isCompressed: false).hexEncodedString())
    }
    
    
    func testPointAddress() throws {

        var  secret = BigInt(888).power(3)
        var mainnet_address = "148dY81A9BmdpMhvYEVznrM45kWN32vSCN"
        var testnet_address = "mieaqB68xDCtbUBYFoUNcmZNwk74xcBfTP"
        var p = secret *  secp256k1Constants.G.point
        var point  = secp256k1Point(x: p.x,y: p.y)
        XCTAssertEqual(mainnet_address, point.p2pkhAddress(isCompressed: true, testnet: false))
        XCTAssertEqual(testnet_address, point.p2pkhAddress(isCompressed: true, testnet: true))
        
        secret = BigInt(321)
        mainnet_address = "1S6g2xBJSED7Qr9CYZib5f4PYVhHZiVfj"
        testnet_address = "mfx3y63A7TfTtXKkv7Y6QzsPFY6QCBCXiP"
        p = secret * secp256k1Constants.G.point
        point  = secp256k1Point(x: p.x,y: p.y)

        XCTAssertEqual(mainnet_address, point.p2pkhAddress(isCompressed: false, testnet: false))
        XCTAssertEqual(testnet_address, point.p2pkhAddress(isCompressed: false, testnet: true))

        secret = BigInt(4242424242)
        mainnet_address = "1226JSptcStqn4Yq9aAmNXdwdc2ixuH9nb"
        testnet_address = "mgY3bVusRUL6ZB2Ss999CSrGVbdRwVpM8s"
        p = secret * secp256k1Constants.G.point
        point  = secp256k1Point(x: p.x,y: p.y)

        XCTAssertEqual(mainnet_address, point.p2pkhAddress(isCompressed: false, testnet: false))
        XCTAssertEqual(testnet_address, point.p2pkhAddress(isCompressed: false, testnet: true))
        
    }
    
    func testSigning() throws {

//        let key  = SecureBytes(bytes: BigInt(4242424242).magnitude.serialize().bytes)
//        let pk = PrivateKey.init(key: key )
//        let z = BigInt("106803335299316304368406718150407005727570940625608758663533317704082257612640")
//        let sig = pk.sign(z:z)
//        XCTAssertTrue(try! pk.point.verify(z: z, sig: sig))
        
    }
    
    
    func testDerBytes() throws {
        
       // 3006020101020102
        let sig = ECDSASignature.init(r: 1, s: 2)
        print(sig.DERBytes().hexEncodedString())
    }
    
    /*
     https://bitcointalk.org/index.php?topic=285142.0
     # Test Vectors for RFC 6979 ECDSA, secp256k1, SHA-256
     # (private key, message, expected k, expected signature)
     test_vectors = [
         (0x1, "Satoshi Nakamoto", 0x8F8A276C19F4149656B280621E358CCE24F5F52542772691EE69063B74F15D15, "934b1ea10a4b3c1757e2b0c017d0b6143ce3c9a7e6a4a49860d7a6ab210ee3d82442ce9d2b916064108014783e923ec36b49743e2ffa1c4496f01a512aafd9e5"),
         (0x1, "All those moments will be lost in time, like tears in rain. Time to die...", 0x38AA22D72376B4DBC472E06C3BA403EE0A394DA63FC58D88686C611ABA98D6B3, "8600dbd41e348fe5c9465ab92d23e3db8b98b873beecd930736488696438cb6b547fe64427496db33bf66019dacbf0039c04199abb0122918601db38a72cfc21"),
         (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364140, "Satoshi Nakamoto", 0x33A19B60E25FB6F4435AF53A3D42D493644827367E6453928554F43E49AA6F90, "fd567d121db66e382991534ada77a6bd3106f0a1098c231e47993447cd6af2d06b39cd0eb1bc8603e159ef5c20a5c8ad685a45b06ce9bebed3f153d10d93bed5"),
         (0xf8b8af8ce3c7cca5e300d33939540c10d45ce001b8f252bfbc57ba0342904181, "Alan Turing", 0x525A82B70E67874398067543FD84C83D30C175FDC45FDEEE082FE13B1D7CFDF1, "7063ae83e7f62bbb171798131b4a0564b956930092b33b07b395615d9ec7e15c58dfcc1e00a35e1572f366ffe34ba0fc47db1e7189759b9fb233c5b05ab388ea"),
         (0xe91671c46231f833a6406ccbea0e3e392c76c167bac1cb013f6f1013980455c2, "There is a computer disease that anybody who works with computers knows about. It's a very serious disease and it interferes completely with the work. The trouble with computers is that you 'play' with them!", 0x1F4B84C23A86A221D233F2521BE018D9318639D5B8BBD6374A8A59232D16AD3D, "b552edd27580141f3b2a5463048cb7cd3e047b97c9f98076c32dbdf85a68718b279fa72dd19bfae05577e06c7c0c1900c371fcd5893f7e1d56a37d30174671f6")
     ]
     */
    func testDetemenisticK() throws {

        let keyB = SecureBytes.init(bytes: BigInt(1).magnitude.serialize().bytes)
       // let p = PrivateKey(key: keyB)
        let message = "Satoshi Nakamoto"
        let z = Helper.sha256(data:  message.data(using: .ascii)!)
       // let sig = p.sign(z: BigInt(BigUInt(z)))
       // print(sig.DERBytes().hexEncodedString())
      //  XCTAssertEqual("934b1ea10a4b3c1757e2b0c017d0b6143ce3c9a7e6a4a49860d7a6ab210ee3d82442ce9d2b916064108014783e923ec36b49743e2ffa1c4496f01a512aafd9e5", sig.DERBytes().hexEncodedString())

        
        
        
    }
    

}

