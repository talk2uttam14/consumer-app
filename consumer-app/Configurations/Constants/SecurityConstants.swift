//
//  SecurityConstants.swift
//  consumer-app
//
//  Client credentials for BlueMarble secured APIs (pre-login).
//  Update these values per environment before release.
//

import Foundation

enum SecurityConstants {

  // MARK: - Client Credentials

  static let clientId = "sndweb"
  static let clientSecret = "0fd30918-5fa0-4ad0-9c8a-445fc5f7c3d9"

  static var base64ClientToken: String {
    Data("\(clientId):\(clientSecret)".utf8).base64EncodedString()
  }

  // MARK: - Default Headers

  static let userAgent = "Java"
  static let acceptHeader = "*/*"
  static let contentType = "application/json;charset=UTF-8"
  static let charset = "utf-8"
  static let language = "en"
}
