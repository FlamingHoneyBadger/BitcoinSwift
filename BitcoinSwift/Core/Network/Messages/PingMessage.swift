//
//  PingMessage.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 6/29/21.
//

import Foundation


class PingMessage {
    static let command = "ping"
    let nonce :Data
    init(input: InputStream) throws {
        nonce = try input.readData(maxLength: 8)
    }
    
    func serialize() -> Data { nonce }
    
}
