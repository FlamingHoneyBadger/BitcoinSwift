//
//  NetworkMessage.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 6/27/21.
//

import Foundation

class NetworkMessage {
    static let TestNet_Start_Const : Data  = "0b110907"
    static let MainNet_Start_Const : Data  = "f9beb4d9"
    var startMessage: Data
    var command : Data
    let commandString : String
    var payload : Data
    
    init(command: Data , payload : Data , testnet:Bool = true) {
        self.command = command
        self.payload = payload
        if(testnet){
            startMessage = NetworkMessage.TestNet_Start_Const
        }else{
            startMessage = NetworkMessage.MainNet_Start_Const
        }
        
        guard let commandString = String( bytes:command.bytes, encoding: .ascii) else {
            self.commandString = "error"
            return
            
        }
        self.commandString = commandString.trimmingCharacters(in: ["\0"])

    }
    convenience init(data: Data, testnet: Bool = true) throws {
        try self.init(input:InputStream(data: data), testnet: testnet)
    }
    init(input: InputStream, testnet: Bool = true) throws {
        input.open()
        defer {
            input.close()
        }
        let start = try input.readData(maxLength: 4)
        self.startMessage = start
        // check to make sure the correct start string is provided
        if(testnet && start != NetworkMessage.TestNet_Start_Const){
            throw NetworkErrors.networkStartStringDoesNotMatch
        }else if(start != NetworkMessage.MainNet_Start_Const){
            throw NetworkErrors.networkStartStringDoesNotMatch
        }
        // pull command bytes
        self.command = try input.readData(maxLength: 12)
        // payload length is 4 byte Little Endian Value
        let payloadLength = try input.readData(maxLength: 4).littleEndianUInt64()
        // read the checksum of the payload
        let checkSum = try input.readData(maxLength: 4)
        // read the payload
        self.payload = try input.readData(maxLength: Int(payloadLength))
        let calulatedCheckSum = Helper.hash256(data: payload)[0..<4]
        print(calulatedCheckSum.hexEncodedString() + "=" + checkSum.hexEncodedString())
        if( calulatedCheckSum != checkSum){
            throw NetworkErrors.checksumDoesNotMatch
        }
        
        guard let commandString = String( bytes:command.bytes, encoding: .ascii) else {
            self.commandString = "error"
            return
            
        }
        self.commandString = commandString.trimmingCharacters(in: ["\0"])
        
    }
    
    func serialize() -> Data{
        var result = Data()
        result.append(startMessage)
        result.append(command)
        result.append(UInt32(payload.bytes.count).littleEndianBytes())
        result.append(Helper.hash256(data: payload)[28..<32])
        result.append(payload)
        return result
    }
    
    
}

enum NetworkErrors : Error {
    case networkStartStringDoesNotMatch
    case checksumDoesNotMatch
    case networkEncodeError

}
