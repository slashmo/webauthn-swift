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
import Crypto

/// The unprocessed response received from `navigator.credentials.create()`.
/// Internally this will be parsed into a more readable `ParsedCredentialCreationResponse`.
public struct RegistrationCredential: Codable {
    public let id: String
    public let type: String
    public let rawID: URLEncodedBase64
    public let attestationResponse: AuthenticatorAttestationResponse

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case rawID = "rawId"
        case attestationResponse = "response"
    }
}

/// The processed response received from `navigator.credentials.create()`.
struct ParsedCredentialCreationResponse {
    let id: String
    let rawID: Data
    /// Value will always be "public-key" (for now)
    let type: String
    let raw: AuthenticatorAttestationResponse
    let response: ParsedAuthenticatorAttestationResponse

    /// Create a `ParsedCredentialCreationResponse` from a raw `CredentialCreationResponse`.
    init(from rawResponse: RegistrationCredential) throws {
        id = rawResponse.id

        guard let decodedRawID = rawResponse.rawID.base64URLDecodedData else {
            throw WebAuthnError.invalidRawID
        }
        rawID = decodedRawID

        guard rawResponse.type == "public-key" else {
            throw WebAuthnError.invalidCredentialCreationType
        }
        type = rawResponse.type

        raw = rawResponse.attestationResponse
        response = try ParsedAuthenticatorAttestationResponse(from: raw)
    }

    func verify(
        storedChallenge: URLEncodedBase64,
        verifyUser: Bool,
        relyingPartyID: String,
        relyingPartyOrigin: String
    ) throws {
        // Step 7. - 9.
        try response.clientData.verify(
            storedChallenge: storedChallenge,
            ceremonyType: .create,
            relyingPartyOrigin: relyingPartyOrigin
        )

        // Step 10.
        guard let clientData = raw.clientDataJSON.data(using: .utf8) else {
            throw WebAuthnError.invalidClientDataJSON
        }
        let hash = SHA256.hash(data: clientData)

        // CBOR decoding happened already. Skipping Step 11.

        // Step 12. - 17.
        try response.attestationObject.verify(
            relyingPartyID: relyingPartyID,
            verificationRequired: verifyUser,
            clientDataHash: hash
        )

        // Step 23.
        guard rawID.count <= 1023 else {
            throw WebAuthnError.credentialRawIDTooBig
        }
    }
}
