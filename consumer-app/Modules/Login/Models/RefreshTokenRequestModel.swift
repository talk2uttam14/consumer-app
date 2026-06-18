//
//  RefreshTokenRequestModel.swift
//  consumer-app
//

import Foundation

struct RefreshTokenRequest: Codable, Sendable {
  let refreshToken: String
}
