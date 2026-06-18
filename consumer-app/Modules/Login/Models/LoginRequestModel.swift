//
//  LoginRequestModel.swift
//  consumer-app
//

import Foundation

struct LoginRequest: Codable, Sendable {
  let mobile: String
  let pin: String
}
