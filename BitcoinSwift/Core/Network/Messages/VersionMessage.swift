//
//  VersionMessage.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 6/29/21.
//

import Foundation


class VersionMessage {
    static let command = "version"

    let version : UInt32
    let services : UInt64
    let timestamp : UInt64
    let receiver_services : UInt64
    let receiverIP : Data
    let receiverPort : UInt16
    let senderIP : Data
    let senderPort : UInt16
    let nonce : Data
    let user_agent : String
    let latestBlock : UInt32
    let relay : Bool

    
    init(version: UInt32=70015, services: UInt64 = 0, timestamp: UInt64 = 0, receiver_services: UInt64 = 0, receiverIP : Data = Data(_: [0x00,0x00,0x00,0x00]) ,
         receiverPort: UInt16 = 8333, senderIP : Data = Data(_: [0x00,0x00,0x00,0x00]) ,senderPort: UInt16 = 8333, nonce: Data = Data(),
         user_agent: String = "bitcoinswift:0.0.1", latestBlock: UInt32 = 0, relay : Bool = false ) {
       
        self.version = version
        self.services = services
        self.timestamp = timestamp
        self.receiver_services = receiver_services
        self.receiverIP = receiverIP
        self.receiverPort = receiverPort
        self.senderIP = senderIP
        self.senderPort = senderPort
        self.nonce = nonce
        self.user_agent = user_agent
        self.latestBlock = latestBlock
        self.relay = relay
        
    }
    
    
    
    func serialize() -> Data {
        var result = Data()
        result.append(version.littleEndianBytes())
        result.append(services.littleEndianBytes())
        result.append(timestamp.littleEndianBytes())
        result.append(receiver_services.littleEndianBytes())
        var rIP : Data
        if(receiverIP.count == 4){
            rIP = Data.init(repeating: 0x00, count: 10)
            rIP.append(Data(_:[0xff,0xff]))
            rIP.append(receiverIP)
        }else{ // TODO: add ipv6
            rIP = receiverIP
        }
        result.append(rIP)
        result.append(receiverPort.bigEndianBytes())
        
        var sIP : Data
        if(receiverIP.count == 4){
            sIP = Data.init(repeating: 0x00, count: 10)
            sIP.append(Data(_:[0xff,0xff]))
            sIP.append(receiverIP)
        }else{ // TODO: add ipv6
            sIP = senderIP
        }
        result.append(sIP)
        result.append(senderPort.bigEndianBytes())
        
        result.append(nonce)
        do{
            print(try Helper.encodeVarInt( UInt64(user_agent.count)))
         result.append( try Helper.encodeVarInt( UInt64(user_agent.count)))
         guard let agent = user_agent.data(using: .ascii) else { throw NetworkErrors.networkEncodeError}
         result.append(agent)
        }catch {
            print("User Agent coulnd not encode")
        }
        
        result.append(latestBlock.littleEndianBytes())
        if relay {
            result.append(0x01)
        }else{
            result.append(0x00)
        }
        
        return result
    }
    
}
