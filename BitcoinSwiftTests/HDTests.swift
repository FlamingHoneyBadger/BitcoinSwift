//
//  HDTests.swift
//  BitcoinSwiftTests
//
//  Created by FlamingHoneyBadger on 7/21/21.
//

import Foundation
import XCTest
import GMP
@testable import BitcoinSwift

class HDTests  : XCTestCase {
    
    let MnemonicTestVectors = "{\n    \"english\": [\n        [\n            \"00000000000000000000000000000000\",\n            \"abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about\",\n            \"c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04\",\n            \"xprv9s21ZrQH143K3h3fDYiay8mocZ3afhfULfb5GX8kCBdno77K4HiA15Tg23wpbeF1pLfs1c5SPmYHrEpTuuRhxMwvKDwqdKiGJS9XFKzUsAF\"\n        ],\n        [\n            \"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f\",\n            \"legal winner thank year wave sausage worth useful legal winner thank yellow\",\n            \"2e8905819b8723fe2c1d161860e5ee1830318dbf49a83bd451cfb8440c28bd6fa457fe1296106559a3c80937a1c1069be3a3a5bd381ee6260e8d9739fce1f607\",\n            \"xprv9s21ZrQH143K2gA81bYFHqU68xz1cX2APaSq5tt6MFSLeXnCKV1RVUJt9FWNTbrrryem4ZckN8k4Ls1H6nwdvDTvnV7zEXs2HgPezuVccsq\"\n        ],\n        [\n            \"80808080808080808080808080808080\",\n            \"letter advice cage absurd amount doctor acoustic avoid letter advice cage above\",\n            \"d71de856f81a8acc65e6fc851a38d4d7ec216fd0796d0a6827a3ad6ed5511a30fa280f12eb2e47ed2ac03b5c462a0358d18d69fe4f985ec81778c1b370b652a8\",\n            \"xprv9s21ZrQH143K2shfP28KM3nr5Ap1SXjz8gc2rAqqMEynmjt6o1qboCDpxckqXavCwdnYds6yBHZGKHv7ef2eTXy461PXUjBFQg6PrwY4Gzq\"\n        ],\n        [\n            \"ffffffffffffffffffffffffffffffff\",\n            \"zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo wrong\",\n            \"ac27495480225222079d7be181583751e86f571027b0497b5b5d11218e0a8a13332572917f0f8e5a589620c6f15b11c61dee327651a14c34e18231052e48c069\",\n            \"xprv9s21ZrQH143K2V4oox4M8Zmhi2Fjx5XK4Lf7GKRvPSgydU3mjZuKGCTg7UPiBUD7ydVPvSLtg9hjp7MQTYsW67rZHAXeccqYqrsx8LcXnyd\"\n        ],\n        [\n            \"000000000000000000000000000000000000000000000000\",\n            \"abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon agent\",\n            \"035895f2f481b1b0f01fcf8c289c794660b289981a78f8106447707fdd9666ca06da5a9a565181599b79f53b844d8a71dd9f439c52a3d7b3e8a79c906ac845fa\",\n            \"xprv9s21ZrQH143K3mEDrypcZ2usWqFgzKB6jBBx9B6GfC7fu26X6hPRzVjzkqkPvDqp6g5eypdk6cyhGnBngbjeHTe4LsuLG1cCmKJka5SMkmU\"\n        ],\n        [\n            \"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f\",\n            \"legal winner thank year wave sausage worth useful legal winner thank year wave sausage worth useful legal will\",\n            \"f2b94508732bcbacbcc020faefecfc89feafa6649a5491b8c952cede496c214a0c7b3c392d168748f2d4a612bada0753b52a1c7ac53c1e93abd5c6320b9e95dd\",\n            \"xprv9s21ZrQH143K3Lv9MZLj16np5GzLe7tDKQfVusBni7toqJGcnKRtHSxUwbKUyUWiwpK55g1DUSsw76TF1T93VT4gz4wt5RM23pkaQLnvBh7\"\n        ],\n        [\n            \"808080808080808080808080808080808080808080808080\",\n            \"letter advice cage absurd amount doctor acoustic avoid letter advice cage absurd amount doctor acoustic avoid letter always\",\n            \"107d7c02a5aa6f38c58083ff74f04c607c2d2c0ecc55501dadd72d025b751bc27fe913ffb796f841c49b1d33b610cf0e91d3aa239027f5e99fe4ce9e5088cd65\",\n            \"xprv9s21ZrQH143K3VPCbxbUtpkh9pRG371UCLDz3BjceqP1jz7XZsQ5EnNkYAEkfeZp62cDNj13ZTEVG1TEro9sZ9grfRmcYWLBhCocViKEJae\"\n        ],\n        [\n            \"ffffffffffffffffffffffffffffffffffffffffffffffff\",\n            \"zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo when\",\n            \"0cd6e5d827bb62eb8fc1e262254223817fd068a74b5b449cc2f667c3f1f985a76379b43348d952e2265b4cd129090758b3e3c2c49103b5051aac2eaeb890a528\",\n            \"xprv9s21ZrQH143K36Ao5jHRVhFGDbLP6FCx8BEEmpru77ef3bmA928BxsqvVM27WnvvyfWywiFN8K6yToqMaGYfzS6Db1EHAXT5TuyCLBXUfdm\"\n        ],\n        [\n            \"0000000000000000000000000000000000000000000000000000000000000000\",\n            \"abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art\",\n            \"bda85446c68413707090a52022edd26a1c9462295029f2e60cd7c4f2bbd3097170af7a4d73245cafa9c3cca8d561a7c3de6f5d4a10be8ed2a5e608d68f92fcc8\",\n            \"xprv9s21ZrQH143K32qBagUJAMU2LsHg3ka7jqMcV98Y7gVeVyNStwYS3U7yVVoDZ4btbRNf4h6ibWpY22iRmXq35qgLs79f312g2kj5539ebPM\"\n        ],\n        [\n            \"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f\",\n            \"legal winner thank year wave sausage worth useful legal winner thank year wave sausage worth useful legal winner thank year wave sausage worth title\",\n            \"bc09fca1804f7e69da93c2f2028eb238c227f2e9dda30cd63699232578480a4021b146ad717fbb7e451ce9eb835f43620bf5c514db0f8add49f5d121449d3e87\",\n            \"xprv9s21ZrQH143K3Y1sd2XVu9wtqxJRvybCfAetjUrMMco6r3v9qZTBeXiBZkS8JxWbcGJZyio8TrZtm6pkbzG8SYt1sxwNLh3Wx7to5pgiVFU\"\n        ],\n        [\n            \"8080808080808080808080808080808080808080808080808080808080808080\",\n            \"letter advice cage absurd amount doctor acoustic avoid letter advice cage absurd amount doctor acoustic avoid letter advice cage absurd amount doctor acoustic bless\",\n            \"c0c519bd0e91a2ed54357d9d1ebef6f5af218a153624cf4f2da911a0ed8f7a09e2ef61af0aca007096df430022f7a2b6fb91661a9589097069720d015e4e982f\",\n            \"xprv9s21ZrQH143K3CSnQNYC3MqAAqHwxeTLhDbhF43A4ss4ciWNmCY9zQGvAKUSqVUf2vPHBTSE1rB2pg4avopqSiLVzXEU8KziNnVPauTqLRo\"\n        ],\n        [\n            \"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\",\n            \"zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo vote\",\n            \"dd48c104698c30cfe2b6142103248622fb7bb0ff692eebb00089b32d22484e1613912f0a5b694407be899ffd31ed3992c456cdf60f5d4564b8ba3f05a69890ad\",\n            \"xprv9s21ZrQH143K2WFF16X85T2QCpndrGwx6GueB72Zf3AHwHJaknRXNF37ZmDrtHrrLSHvbuRejXcnYxoZKvRquTPyp2JiNG3XcjQyzSEgqCB\"\n        ],\n        [\n            \"9e885d952ad362caeb4efe34a8e91bd2\",\n            \"ozone drill grab fiber curtain grace pudding thank cruise elder eight picnic\",\n            \"274ddc525802f7c828d8ef7ddbcdc5304e87ac3535913611fbbfa986d0c9e5476c91689f9c8a54fd55bd38606aa6a8595ad213d4c9c9f9aca3fb217069a41028\",\n            \"xprv9s21ZrQH143K2oZ9stBYpoaZ2ktHj7jLz7iMqpgg1En8kKFTXJHsjxry1JbKH19YrDTicVwKPehFKTbmaxgVEc5TpHdS1aYhB2s9aFJBeJH\"\n        ],\n        [\n            \"6610b25967cdcca9d59875f5cb50b0ea75433311869e930b\",\n            \"gravity machine north sort system female filter attitude volume fold club stay feature office ecology stable narrow fog\",\n            \"628c3827a8823298ee685db84f55caa34b5cc195a778e52d45f59bcf75aba68e4d7590e101dc414bc1bbd5737666fbbef35d1f1903953b66624f910feef245ac\",\n            \"xprv9s21ZrQH143K3uT8eQowUjsxrmsA9YUuQQK1RLqFufzybxD6DH6gPY7NjJ5G3EPHjsWDrs9iivSbmvjc9DQJbJGatfa9pv4MZ3wjr8qWPAK\"\n        ],\n        [\n            \"68a79eaca2324873eacc50cb9c6eca8cc68ea5d936f98787c60c7ebc74e6ce7c\",\n            \"hamster diagram private dutch cause delay private meat slide toddler razor book happy fancy gospel tennis maple dilemma loan word shrug inflict delay length\",\n            \"64c87cde7e12ecf6704ab95bb1408bef047c22db4cc7491c4271d170a1b213d20b385bc1588d9c7b38f1b39d415665b8a9030c9ec653d75e65f847d8fc1fc440\",\n            \"xprv9s21ZrQH143K2XTAhys3pMNcGn261Fi5Ta2Pw8PwaVPhg3D8DWkzWQwjTJfskj8ofb81i9NP2cUNKxwjueJHHMQAnxtivTA75uUFqPFeWzk\"\n        ],\n        [\n            \"c0ba5a8e914111210f2bd131f3d5e08d\",\n            \"scheme spot photo card baby mountain device kick cradle pact join borrow\",\n            \"ea725895aaae8d4c1cf682c1bfd2d358d52ed9f0f0591131b559e2724bb234fca05aa9c02c57407e04ee9dc3b454aa63fbff483a8b11de949624b9f1831a9612\",\n            \"xprv9s21ZrQH143K3FperxDp8vFsFycKCRcJGAFmcV7umQmcnMZaLtZRt13QJDsoS5F6oYT6BB4sS6zmTmyQAEkJKxJ7yByDNtRe5asP2jFGhT6\"\n        ],\n        [\n            \"6d9be1ee6ebd27a258115aad99b7317b9c8d28b6d76431c3\",\n            \"horn tenant knee talent sponsor spell gate clip pulse soap slush warm silver nephew swap uncle crack brave\",\n            \"fd579828af3da1d32544ce4db5c73d53fc8acc4ddb1e3b251a31179cdb71e853c56d2fcb11aed39898ce6c34b10b5382772db8796e52837b54468aeb312cfc3d\",\n            \"xprv9s21ZrQH143K3R1SfVZZLtVbXEB9ryVxmVtVMsMwmEyEvgXN6Q84LKkLRmf4ST6QrLeBm3jQsb9gx1uo23TS7vo3vAkZGZz71uuLCcywUkt\"\n        ],\n        [\n            \"9f6a2878b2520799a44ef18bc7df394e7061a224d2c33cd015b157d746869863\",\n            \"panda eyebrow bullet gorilla call smoke muffin taste mesh discover soft ostrich alcohol speed nation flash devote level hobby quick inner drive ghost inside\",\n            \"72be8e052fc4919d2adf28d5306b5474b0069df35b02303de8c1729c9538dbb6fc2d731d5f832193cd9fb6aeecbc469594a70e3dd50811b5067f3b88b28c3e8d\",\n            \"xprv9s21ZrQH143K2WNnKmssvZYM96VAr47iHUQUTUyUXH3sAGNjhJANddnhw3i3y3pBbRAVk5M5qUGFr4rHbEWwXgX4qrvrceifCYQJbbFDems\"\n        ],\n        [\n            \"23db8160a31d3e0dca3688ed941adbf3\",\n            \"cat swing flag economy stadium alone churn speed unique patch report train\",\n            \"deb5f45449e615feff5640f2e49f933ff51895de3b4381832b3139941c57b59205a42480c52175b6efcffaa58a2503887c1e8b363a707256bdd2b587b46541f5\",\n            \"xprv9s21ZrQH143K4G28omGMogEoYgDQuigBo8AFHAGDaJdqQ99QKMQ5J6fYTMfANTJy6xBmhvsNZ1CJzRZ64PWbnTFUn6CDV2FxoMDLXdk95DQ\"\n        ],\n        [\n            \"8197a4a47f0425faeaa69deebc05ca29c0a5b5cc76ceacc0\",\n            \"light rule cinnamon wrap drastic word pride squirrel upgrade then income fatal apart sustain crack supply proud access\",\n            \"4cbdff1ca2db800fd61cae72a57475fdc6bab03e441fd63f96dabd1f183ef5b782925f00105f318309a7e9c3ea6967c7801e46c8a58082674c860a37b93eda02\",\n            \"xprv9s21ZrQH143K3wtsvY8L2aZyxkiWULZH4vyQE5XkHTXkmx8gHo6RUEfH3Jyr6NwkJhvano7Xb2o6UqFKWHVo5scE31SGDCAUsgVhiUuUDyh\"\n        ],\n        [\n            \"066dca1a2bb7e8a1db2832148ce9933eea0f3ac9548d793112d9a95c9407efad\",\n            \"all hour make first leader extend hole alien behind guard gospel lava path output census museum junior mass reopen famous sing advance salt reform\",\n            \"26e975ec644423f4a4c4f4215ef09b4bd7ef924e85d1d17c4cf3f136c2863cf6df0a475045652c57eb5fb41513ca2a2d67722b77e954b4b3fc11f7590449191d\",\n            \"xprv9s21ZrQH143K3rEfqSM4QZRVmiMuSWY9wugscmaCjYja3SbUD3KPEB1a7QXJoajyR2T1SiXU7rFVRXMV9XdYVSZe7JoUXdP4SRHTxsT1nzm\"\n        ],\n        [\n            \"f30f8c1da665478f49b001d94c5fc452\",\n            \"vessel ladder alter error federal sibling chat ability sun glass valve picture\",\n            \"2aaa9242daafcee6aa9d7269f17d4efe271e1b9a529178d7dc139cd18747090bf9d60295d0ce74309a78852a9caadf0af48aae1c6253839624076224374bc63f\",\n            \"xprv9s21ZrQH143K2QWV9Wn8Vvs6jbqfF1YbTCdURQW9dLFKDovpKaKrqS3SEWsXCu6ZNky9PSAENg6c9AQYHcg4PjopRGGKmdD313ZHszymnps\"\n        ],\n        [\n            \"c10ec20dc3cd9f652c7fac2f1230f7a3c828389a14392f05\",\n            \"scissors invite lock maple supreme raw rapid void congress muscle digital elegant little brisk hair mango congress clump\",\n            \"7b4a10be9d98e6cba265566db7f136718e1398c71cb581e1b2f464cac1ceedf4f3e274dc270003c670ad8d02c4558b2f8e39edea2775c9e232c7cb798b069e88\",\n            \"xprv9s21ZrQH143K4aERa2bq7559eMCCEs2QmmqVjUuzfy5eAeDX4mqZffkYwpzGQRE2YEEeLVRoH4CSHxianrFaVnMN2RYaPUZJhJx8S5j6puX\"\n        ],\n        [\n            \"f585c11aec520db57dd353c69554b21a89b20fb0650966fa0a9d6f74fd989d8f\",\n            \"void come effort suffer camp survey warrior heavy shoot primary clutch crush open amazing screen patrol group space point ten exist slush involve unfold\",\n            \"01f5bced59dec48e362f2c45b5de68b9fd6c92c6634f44d6d40aab69056506f0e35524a518034ddc1192e1dacd32c1ed3eaa3c3b131c88ed8e7e54c49a5d0998\",\n            \"xprv9s21ZrQH143K39rnQJknpH1WEPFJrzmAqqasiDcVrNuk926oizzJDDQkdiTvNPr2FYDYzWgiMiC63YmfPAa2oPyNB23r2g7d1yiK6WpqaQS\"\n        ]\n    ]\n}"
    
    
    func testPBKDF2forMnemonic() throws {
       let st = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
       let password = "TREZOR"
       let expected = "c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04"
        let seed = Helper.PBKDF2_HMAC_SHA512_(mnemonic: st, password: password)
       XCTAssertEqual(expected, seed.hexEncodedString())
        
        // Compute HMAC-SHA512 of seed
        //        seed = hmac.new(b"Bitcoin seed", seed, digestmod=hashlib.sha512).digest()
        let seed1 = Helper.hmacSha512(key:Data("Bitcoin seed".utf8), message: seed)
        print(seed1.hexEncodedString())
        var xprv = Data();
        xprv.append(contentsOf: [0x04,0x88,0xad,0xe4]) // Version for private mainnet
        xprv.append(Data([0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]))
        xprv.append(seed1[32...seed.count-1]) //chain code
        xprv.append(0x00)
        xprv.append(seed1[0...31]) // master key
        XCTAssertEqual("xprv9s21ZrQH143K3h3fDYiay8mocZ3afhfULfb5GX8kCBdno77K4HiA15Tg23wpbeF1pLfs1c5SPmYHrEpTuuRhxMwvKDwqdKiGJS9XFKzUsAF", xprv.base58EncodeWithCheckSum())

        
    }
    
    
    func testMnemonicTest1() {
        let st = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        var walletSeed = "00000000000000000000000000000000".hexadecimal!
        let mnemonic = Mnemonic(input: walletSeed)
        XCTAssertEqual(st, mnemonic.mnemonicWordList)

    }
    
    func testMnemonicTest2() {
        let st = "legal winner thank year wave sausage worth useful legal winner thank yellow"

        var walletSeed = "7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f".hexadecimal!
        let mnemonic = Mnemonic(input: walletSeed)
        XCTAssertEqual(st, mnemonic.mnemonicWordList)

    }
    
    func testMnemonicTest3() {
        let st = "letter advice cage absurd amount doctor acoustic avoid letter advice cage above"

        var walletSeed = "80808080808080808080808080808080".hexadecimal!
        let mnemonic = Mnemonic(input: walletSeed)
        XCTAssertEqual(st, mnemonic.mnemonicWordList)

    }
    
    func testBIP39TestVectors() {
        let data = Data(MnemonicTestVectors.utf8)

        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                if let tests = json["english"] as? [[String]] {
                        // access nested dictionary values
                    for test in tests {
                        let walletSeed = test[0].hexadecimal!
                        let mnemonic = Mnemonic(input: walletSeed , testnet: false)
                        XCTAssertEqual(test[1], mnemonic.mnemonicWordList)
                        XCTAssertEqual(test[2], mnemonic.toSeed(passphrase: "TREZOR").hexEncodedString())
                        XCTAssertEqual(test[3], mnemonic.toHDMasterKey(passphrase: "TREZOR").base58EncodeWithCheckSum())

                    }
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
    }
}
