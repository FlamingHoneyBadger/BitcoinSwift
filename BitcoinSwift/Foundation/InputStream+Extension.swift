//
// Created by FlamingHoneyBadger on 6/5/21.
// Copyright (c) 2021  by FlamingHoneyBadger All rights reserved.
//

import Foundation

extension InputStream {
    func readData(maxLength length: Int) throws -> Data {
        var buffer = [UInt8](repeating: 0, count: length)
        let result = self.read(&buffer, maxLength: buffer.count)
        if result < 0 {
            throw self.streamError ?? POSIXError(.EIO)
        } else {
            return Data(buffer.prefix(result))
        }
    }
}