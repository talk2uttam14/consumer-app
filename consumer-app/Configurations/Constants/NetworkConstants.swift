//
//  NetworkConstants.swift
//  consumer-app
//

import Foundation

enum NetworkConstants {

  static var baseUrl: String { EnvironmentConstants.baseURLString }
  static var referer: String { EnvironmentConstants.baseURLString }

  static let requestTimeout: TimeInterval = 30
  static let maxRetryCount = 3
  static let defaultTokenExpiresIn: TimeInterval = 3600

  /// Endpoints that automatically append `?language=` query param.
  static let supportLanguageQuery: [String] = [
    EndpointConstants.getEndpoints.getLanguages
  ]

  /// Default values used on first load (before user selection).
  enum Default {
    static let tenantTerm = "TENANT_ID"
  }
}
