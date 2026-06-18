//
//  CryptoHelper.swift
//  consumer-app
//
//  Crypto helpers for BlueMarble security headers.
//

import CryptoKit
import Foundation

enum CryptoHelper {

  private static let defaultNonceLength = 16
  private static let alphanumericCharacters = Array(
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  )

  /// HMAC-SHA256 hex string used for Signature and X-Watermark headers.
  static func hmacSHA256(message: String, key: String) -> String {
    let symmetricKey = SymmetricKey(data: Data(key.utf8))
    let digest = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: symmetricKey)
    return digest.map { String(format: "%02hhx", $0) }.joined()
  }

  /// Random string for the `Nonce` header.
  static func generateRandomNonce(length: Int = defaultNonceLength) -> String {
    guard length > 0 else { return "" }

    let randomBytes = Array(SymmetricKey(size: .bits256).withUnsafeBytes { Data($0) })
    return String(
      (0..<length).map { index in
        let byte = randomBytes[index % randomBytes.count]
        return alphanumericCharacters[Int(byte) % alphanumericCharacters.count]
      }
    )
  }

  /// Base64 encoded value for `X-Security-Nonce` header.
  static func generateSecurityNonce() -> String {
    let payload = "\(normalizedUUID()).\(currentTimestampInMilliseconds())"
    return Data(payload.utf8).base64EncodedString()
  }
}

// MARK: - Private

private extension CryptoHelper {

  static func normalizedUUID() -> String {
    UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
  }

  static func currentTimestampInMilliseconds() -> UInt64 {
    UInt64(Date().timeIntervalSince1970 * 1_000)
  }
}
