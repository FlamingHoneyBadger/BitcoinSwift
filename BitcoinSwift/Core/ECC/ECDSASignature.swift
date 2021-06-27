//
//  ECDSASignature.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 5/20/21.
//

import Foundation
import GMP

public class ECDSASignature  {


    var r :GMPInteger
    var s: GMPInteger
    
    public init(r: GMPInteger, s: GMPInteger) {
        self.r = r
        self.s = s
    }
    
    public func description() -> String {
        return "Signature(\(r) ,\(s))"
    }
    
    
    public func DERBytes() -> Data {
        var prefix = Data(repeating:0x30,count:1)
        var rbin = Data(GMPInteger.bytes(r))
        var sbin = Data(GMPInteger.bytes(s))
        var result = Data()

        if((rbin.first! & 0x80) != 0){
            rbin =  Data(repeating:0x00,count:1)
            rbin.append(Data(GMPInteger.bytes(r)))
        }
        result.append(0x02)
        result.append(UInt8(rbin.count))
        result.append(rbin)

        if((sbin.first! & 0x80) != 0){
            sbin =  Data(repeating:0x00,count:1)
            sbin.append(Data(GMPInteger.bytes(s)))
        }
        result.append(0x02)
        result.append(UInt8(sbin.count))
        result.append(sbin)

        prefix.append(UInt8(result.count))
        prefix.append(result)
        return prefix
    }
    
    public convenience init(_ data: Data) throws {
        print(data.hexEncodedString())
        let input = InputStream(data: data)
        input.open()
        defer {
            input.close()
        }
       try self.init(input)
    }
    
    
    public init(_ data: InputStream) throws {
        let compound = try data.readData(maxLength: 1).bytes[0]
        
        
        if(compound != 0x30){
            throw ECDSAError.ParseErrorBadSignature
        }
        let length = try data.readData(maxLength: 1).bytes[0]
        var marker = try data.readData(maxLength: 1).bytes[0]
        if(marker != 0x02){
            throw ECDSAError.ParseErrorBadSignature
        }
        
        let rLength = try data.readData(maxLength: 1).bytes[0]
        r =  GMPInteger.init(try data.readData(maxLength: Int(rLength)))
        
        marker = try data.readData(maxLength: 1).bytes[0]
        if(marker != 0x02){
            throw ECDSAError.ParseErrorBadSignature
        }
        
        let sLength = try data.readData(maxLength: 1).bytes[0]
        s =  GMPInteger.init(try data.readData(maxLength: Int(sLength)))
        
        if(length != 4 +  rLength + sLength){
            throw ECDSAError.ParseErrorBadLength
        }
    }

    enum ECDSAError : Error {
        case ParseErrorBadSignature
        case ParseErrorBadLength
    }
    

}
