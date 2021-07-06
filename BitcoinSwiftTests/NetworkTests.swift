//
//  NetworkTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 6/29/21.
//

import Foundation
import XCTest
import GMP
@testable import BitcoinSwift

class NetworkTests  : XCTestCase {
    
    func testParseVerAck() throws {
        let msg : Data = "f9beb4d976657261636b000000000000000000005df6e0e2"
        let payload : Data = ""
        let message = try NetworkMessage.init(data: msg, testnet: false)
        guard let  command =  String( bytes:message.command.bytes, encoding: .ascii) else { return XCTAssertTrue(false) }
        print(command)
        XCTAssertEqual(message.startMessage, NetworkMessage.MainNet_Start_Const)
        XCTAssertEqual(message.payload, payload)
        XCTAssertEqual(message.commandString, "verack")

    }
    
    func testParseVersion() throws {
        let msg : Data = "f9beb4d976657273696f6e0000000000650000005f1a69d2721101000100000000000000bc8f5e5400000000010000000000000000000000000000000000ffffc61b6409208d010000000000000000000000000000000000ffffcb0071c0208d128035cbc97953f80f2f5361746f7368693a302e392e332fcf05050001"
        let payload : Data = "721101000100000000000000bc8f5e5400000000010000000000000000000000000000000000ffffc61b6409208d010000000000000000000000000000000000ffffcb0071c0208d128035cbc97953f80f2f5361746f7368693a302e392e332fcf05050001"
        let message = try NetworkMessage.init(data: msg, testnet: false)
        guard let  command =  String( bytes:message.command.bytes, encoding: .ascii) else { return XCTAssertTrue(false) }
        print(command)
        print(payload.hexEncodedString())
        XCTAssertEqual(message.startMessage, NetworkMessage.MainNet_Start_Const)
        XCTAssertEqual(message.payload, payload)
        XCTAssertEqual(message.commandString, "version")
    }
    
    func testVersionMessage() throws {
        let msg : Data = "7f11010000000000000000000000000000000000000000000000000000000000000000000000ffff00000000208d000000000000000000000000000000000000ffff00000000208d0000000000000000182f70726f6772616d6d696e67626974636f696e3a302e312f0000000000"
        
        let v = VersionMessage(timestamp: 0, nonce: Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]),user_agent: "programmingbitcoin:0.1")
        
        
        let s = v.serialize().hexEncodedString()
        
    }
    
    

}
