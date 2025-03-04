//===----------------------------------------------------------------------===//
//
// This source file is part of the WebAuthn Swift open source project
//
// Copyright (c) 2022 the WebAuthn Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of WebAuthn Swift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import Logging

public typealias URLEncodedBase64 = String
public typealias EncodedBase64 = String

extension Array where Element == UInt8 {
    /// Encodes an array of bytes into a base64url-encoded string
    /// - Returns: A base64url-encoded string
    public func base64URLEncodedString() -> String {
        let base64String = Data(bytes: self, count: self.count).base64EncodedString()
        return String.base64URL(fromBase64: base64String)
    }

    /// Encodes an array of bytes into a base64 string
    /// - Returns: A base64-encoded string
    public func base64EncodedString() -> String {
        return Data(bytes: self, count: self.count).base64EncodedString()
    }
}

extension Data {
    /// Encodes data into a base64url-encoded string
    /// - Returns: A base64url-encoded string
    public func base64URLEncodedString() -> String {
        return [UInt8](self).base64URLEncodedString()
    }
}

extension String {
    /// Decode a base64url-encoded `String` to a base64 `String`
    /// - Returns: A base64-encoded `String`
    public static func base64(fromBase64URLEncoded base64URLEncoded: String) -> Self {
        return base64URLEncoded.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
    }

    public static func base64URL(fromBase64 base64Encoded: String) -> Self {
        return base64Encoded.replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension String {
    public var base64URLDecodedData: Data? {
        var result = self.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        while result.count % 4 != 0 {
            result = result.appending("=")
        }
        return Data(base64Encoded: result)
    }
}
