//
// Created by FlamingHoneyBadger on 6/2/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation


enum OP_CODE_FUNCTIONS : UInt8 {
    case OP_0 = 0
    case OP_PUSHDATA1 = 76
    case OP_PUSHDATA2 = 77
    case OP_PUSHDATA4 = 78
    case OP_1NEGATE = 79
    case OP_1 = 81
    case OP_2 = 82
    case OP_3 = 83
    case OP_4 = 84
    case OP_5 = 85
    case OP_6 = 86
    case OP_7 = 87
    case OP_8 = 88
    case OP_9 = 89
    case OP_10 = 90
    case OP_11 = 91
    case OP_12 = 92
    case OP_13 = 93
    case OP_14 = 94
    case OP_15 = 95
    case OP_16 = 96
    case OP_NOP = 97
    case OP_IF = 99
    case OP_NOTIF = 100
    case OP_ELSE = 103
    case OP_ENDIF = 104
    case OP_VERIFY = 105
    case OP_RETURN = 106
    case OP_TOALTSTACK = 107
    case OP_FROMALTSTACK = 108
    case OP_2DROP = 109
    case OP_2DUP = 110
    case OP_3DUP
    case OP_2OVER
    case OP_2ROT
    case OP_2SWAP
    case OP_IFDUP
    case OP_DEPTH
    case OP_DROP
    case OP_DUP
    case OP_NIP
    case OP_OVER
    case OP_PICK
    case OP_ROLL
    case OP_ROT
    case OP_SWAP
    case OP_TUCK
    case OP_SIZE
    case OP_EQUAL
    case OP_EQUALVERIFY
    case OP_1ADD
    case OP_1SUB
    case OP_NEGATE
    case OP_ABS
    case OP_NOT
    case OP_0NOTEQUAL
    case OP_ADD
    case OP_SUB
    case OP_BOOLAND
    case OP_BOOLOR
    case OP_NUMEQUAL
    case OP_NUMEQUALVERIFY
    case OP_NUMNOTEQUAL
    case OP_LESSTHAN
    case OP_GREATERTHAN
    case OP_LESSTHANOREQUAL
    case OP_GREATERTHANOREQUAL
    case OP_MIN
    case OP_MAX
    case OP_WITHIN
    case OP_RIPEMD160
    case OP_SHA1
    case OP_SHA256
    case OP_HASH160
    case OP_HASH256
    case OP_CODESEPARATOR
    case OP_CHECKSIG
    case OP_CHECKSIGVERIFY
    case OP_CHECKMULTISIG
    case OP_CHECKMULTISIGVERIFY
    case OP_NOP1
    case OP_CHECKLOCKTIMEVERIFY
    case OP_CHECKSEQUENCEVERIFY
    case OP_NOP4
    case OP_NOP5
    case OP_NOP6
    case OP_NOP7
    case OP_NOP8
    case OP_NOP9
    case OP_NOP10
}