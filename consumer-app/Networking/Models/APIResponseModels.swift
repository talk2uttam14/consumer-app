//
//  APIResponseModels.swift
//  consumer-app
//
//  Shared decode wrappers used by APIManager.
//

import Foundation

struct AnyEncodable: Encodable {
  private let encodeFunc: (Encoder) throws -> Void

  init<T: Encodable>(_ value: T) {
    self.encodeFunc = value.encode
  }

  func encode(to encoder: Encoder) throws {
    try encodeFunc(encoder)
  }
}

struct APIResponse<T: Decodable>: Decodable {
  let errorCode: Int
  let success: Bool
  let refreshToken: Bool
  let message: String
  let payload: T
}

struct ErrorResponseModel: Codable {
  let errorCode: Int?
  let success: Bool?
  let refreshToken: Bool?
  let message: String?
  let reason: String?

  enum CodingKeys: String, CodingKey {
    case errorCode, success, refreshToken, message, reason
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    errorCode = try container.decodeIfPresent(Int.self, forKey: .errorCode)
    success = try container.decodeIfPresent(Bool.self, forKey: .success)
    refreshToken = try container.decodeIfPresent(Bool.self, forKey: .refreshToken)
    message = try container.decodeIfPresent(String.self, forKey: .message)
    reason = try container.decodeIfPresent(String.self, forKey: .reason)
  }
}
