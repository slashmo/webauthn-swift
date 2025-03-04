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

public enum WebAuthnError: Error {
    // MARK: Shared
    case invalidClientDataJSON
    case attestedCredentialDataMissing
    case relyingPartyIDHashDoesNotMatch
    case userPresentFlagNotSet
    case invalidSignature

    // MARK: AttestationObject
    case userVerificationRequiredButFlagNotSet
    case attestationStatementMissing
    case attestationVerificationNotSupported

    // MARK: WebAuthnManager
    case invalidUserID
    case unsupportedCredentialPublicKeyAlgorithm
    case credentialIDAlreadyExists
    case invalidAuthenticatorData
    case invalidRelyingPartyID
    case userVerifiedFlagNotSet
    case potentialReplayAttack
    case invalidAssertionCredentialType

    // MARK: ParsedAuthenticatorAttestationResponse
    case invalidAttestationData
    case invalidAuthData
    case invalidFmt
    case invalidAttStmt
    case attestationFormatNotSupported

    // MARK: ParsedCredentialCreationResponse
    case invalidRawID
    case invalidCredentialCreationType
    case credentialRawIDTooBig

    // MARK: AuthenticatorData
    case authDataTooShort
    case attestedCredentialFlagNotSet
    case extensionDataMissing
    case leftOverBytesInAuthenticatorData

    // MARK: CredentialPublicKey
    case badPublicKeyBytes
    case invalidKeyType
    case invalidAlgorithm
    case invalidCurve
    case invalidXCoordinate
    case invalidYCoordinate
    case unsupportedCOSEAlgorithm
    case unsupportedCOSEAlgorithmForEC2PublicKey
    case invalidModulus
    case invalidExponent
    case unsupportedCOSEAlgorithmForRSAPublicKey
}
