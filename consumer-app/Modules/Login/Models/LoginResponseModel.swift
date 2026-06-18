//
//  LoginResponseModel.swift
//  consumer-app
//

import Foundation

struct LoginResponse: Decodable, BlueMarbleResponse, Sendable {
  let errorCode: Int
  let success: Bool
  let refreshToken: Bool?
  let message: String
  let payload: LoginPayload?
}

struct LoginPayload: Decodable, Sendable {
  let accessToken: String?
  let refreshToken: String?
}
