//
//  ContentView.swift
//  hostApp
//
//  Created by gentian kruja on 5/25/21.
//

import SwiftUI
import BigInt
import BitcoinSwift

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
        Button("verify") {
            let startDate = Date()
            let z = BigInt("106803335299316304368406718150407005727570940625608758663533317704082257612640")
            let r = BigInt("78047132305074547209667415378684003360790728528333174453334458954808711947157")
            let s = BigInt("2945795152904547855448158643091235482997756069461486099501216307557115896772")
            let point =  secp256k1Point.init(x: BigInt("61718672711110078285455301750480400966627255360668707636501858927943098880108"),
                                                y: BigInt("44267342672039291314052509441658516950140155852350072275186874907549665111604"))
            DispatchQueue.global(qos: .userInitiated).async {
                print("This is run on a background queue")

                let sig = ECDSASignature.init(r: r, s: s)
                if( point.verify(z: z, sig: sig)){
                //print(sig.DERBytes().hexEncodedString())
                    print(fabs(startDate.timeIntervalSinceNow) * 1000)
                }else{
                    print("signature failed")
                    print(fabs(startDate.timeIntervalSinceNow) * 1000)
                }
            }
            
        }
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
