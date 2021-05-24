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
        let point = try secp256k1Point.init(x: BigInt("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                            y: BigInt("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
        let sig = ECDSASignature.init(r: r, s: s)
        self.measure {
            DispatchQueue.global(qos: .userInitiated).async {
                XCTAssertTrue(try! point.verify(z: z, sig: sig))
            }
        }
    }
    
    func testVerify2() throws {
        let z = BigInt("56099933801250147507530887846013995861658484709398205753844016085871945288253")
        let r = BigInt("423978563313610541820751014531939415111138679983830741516375588441135684140")
        let s = BigInt("90067678915080561991476742139334357116447229582337733602832701972810841451190")
        let point = try secp256k1Point.init(x: BigInt("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                            y: BigInt("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
        let sig = ECDSASignature.init(r: r, s: s)
        self.measure {
            DispatchQueue.global(qos: .userInitiated).async {
            XCTAssertTrue(try! point.verify(z: z, sig: sig))
            }
        }
        
        }
    
    func testSecEncode1() throws {

        var coefficient = BigInt(999)
        coefficient = coefficient.power(3)
        let uncompressed = "049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9"
        let compressed = "039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5"
        let point = coefficient * secp256k1Constants.G

        let myC =  point.SecBytes(isCompressed: true).hexEncodedString()
        let myUC =  point.SecBytes(isCompressed: false).hexEncodedString()

        XCTAssertEqual(compressed, myC)
        XCTAssertEqual(uncompressed, myUC)
    }
    
    func testSecEncode2() throws {

        let coefficient = BigInt(123)
        let uncompressed = "04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
        let compressed = "03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5"
        let point = coefficient * secp256k1Constants.G

        let myC =  point.SecBytes(isCompressed: true).hexEncodedString()
        let myUC =  point.SecBytes(isCompressed: false).hexEncodedString()

        XCTAssertEqual(compressed, myC)
        XCTAssertEqual(uncompressed, myUC)
    }
    
    func testSecEncode3() throws {

        let coefficient = BigInt(42424242)
        let uncompressed = "04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3"
        let compressed = "03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e"
        let point = coefficient * secp256k1Constants.G

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
        DispatchQueue.global(qos: .userInitiated).async {

        var  secret = BigInt(888).power(3)
        var mainnet_address = "148dY81A9BmdpMhvYEVznrM45kWN32vSCN"
        var testnet_address = "mieaqB68xDCtbUBYFoUNcmZNwk74xcBfTP"
        var point = secret *  secp256k1Constants.G
        
        XCTAssertEqual(mainnet_address, point.p2pkhAddress(isCompressed: true, testnet: false))
        XCTAssertEqual(testnet_address, point.p2pkhAddress(isCompressed: true, testnet: true))
        
        secret = BigInt(321)
        mainnet_address = "1S6g2xBJSED7Qr9CYZib5f4PYVhHZiVfj"
        testnet_address = "mfx3y63A7TfTtXKkv7Y6QzsPFY6QCBCXiP"
        point = secret * secp256k1Constants.G
        XCTAssertEqual(mainnet_address, point.p2pkhAddress(isCompressed: false, testnet: false))
        XCTAssertEqual(testnet_address, point.p2pkhAddress(isCompressed: false, testnet: true))

        secret = BigInt(4242424242)
        mainnet_address = "1226JSptcStqn4Yq9aAmNXdwdc2ixuH9nb"
        testnet_address = "mgY3bVusRUL6ZB2Ss999CSrGVbdRwVpM8s"
        point = secret * secp256k1Constants.G
        XCTAssertEqual(mainnet_address, point.p2pkhAddress(isCompressed: false, testnet: false))
        XCTAssertEqual(testnet_address, point.p2pkhAddress(isCompressed: false, testnet: true))
        }
    }
    
    func testSigning() throws {
        DispatchQueue.global(qos: .userInitiated).async {

        let key  = SecureBytes(bytes: BigInt(4242424242).magnitude.serialize().bytes)
        let pk = PrivateKey.init(key: key )
        let z = BigInt("106803335299316304368406718150407005727570940625608758663533317704082257612640")
        let sig = pk.sign(z:z)
        XCTAssertTrue(try! pk.point.verify(z: z, sig: sig))
        }
    }
    
    func testDetemenisticK(){
        
    }
    

}
