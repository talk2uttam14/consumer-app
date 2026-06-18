//
//  Interceptors.swift
//  consumer-app
//

import Foundation

public protocol RequestInterceptor {
  func adapt(_ request: URLRequest) async throws -> URLRequest
  func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool
}

public struct TokenRefreshResult: Sendable {
  public let accessToken: String
  public let refreshToken: String?
  public let expiresIn: TimeInterval

  public init(accessToken: String, refreshToken: String?, expiresIn: TimeInterval) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.expiresIn = expiresIn
  }
}

public typealias TokenRefreshHandler = @Sendable (String) async throws -> TokenRefreshResult

public actor Authenticator {

  private let storage = SecureStorage.shared
  private let tokenKey = KeyChainConstants.accessTokenKey
  private let tokenExpiryKey = KeyChainConstants.tokenExpiryKey
  private let refreshTokenKey = KeyChainConstants.refreshTokenKey

  private var refreshTask: Task<String, Error>?
  private var refreshHandler: TokenRefreshHandler?

  public init() {}

  func setRefreshHandler(_ handler: @escaping TokenRefreshHandler) {
    refreshHandler = handler
  }

  // MARK: - Current Token

  public func currentToken() async -> String? {
    if await isTokenExpired() {
      return nil
    }
    return try? storage.retrieve(key: tokenKey)
  }

  // MARK: - Save Login Session

  public func saveLoginSession(
    accessToken: String,
    refreshToken: String?,
    mobile: String
  ) throws {
    try setToken(accessToken, expiresIn: NetworkConstants.defaultTokenExpiresIn)
    if let refreshToken, !refreshToken.isEmpty {
      try setRefreshToken(refreshToken)
    }
    try storage.save(key: KeyChainConstants.userMobileKey, value: mobile)
  }

  // MARK: - Set Token

  public func setToken(_ token: String, expiresIn: TimeInterval) throws {
    try storage.save(key: tokenKey, value: token)
    let expiryDate = Date().addingTimeInterval(expiresIn)
    try storage.save(key: tokenExpiryKey, value: "\(expiryDate.timeIntervalSince1970)")
  }

  public func setRefreshToken(_ refreshToken: String) throws {
    try storage.save(key: refreshTokenKey, value: refreshToken)
  }

  private func isTokenExpired() async -> Bool {
    guard let expiryString = try? storage.retrieve(key: tokenExpiryKey),
          let expiryTimestamp = Double(expiryString) else {
      return true
    }

    let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
    return Date().addingTimeInterval(60) >= expiryDate
  }

  // MARK: - Refresh Token

  public func refreshTokenIfNeeded() async throws -> String {
    if let token = await currentToken() {
      return token
    }

    if let task = refreshTask {
      return try await task.value
    }

    refreshTask = Task {
      try await performTokenRefresh()
    }

    defer { refreshTask = nil }
    return try await refreshTask!.value
  }

  private func performTokenRefresh() async throws -> String {
    guard let refreshToken = try? storage.retrieve(key: refreshTokenKey) else {
      throw AppError.network(.unauthorized)
    }
    guard let refreshHandler else {
      throw AppError.network(.unauthorized)
    }

    let result = try await refreshHandler(refreshToken)
    try setToken(result.accessToken, expiresIn: result.expiresIn)
    if let newRefreshToken = result.refreshToken, !newRefreshToken.isEmpty {
      try setRefreshToken(newRefreshToken)
    }
    return result.accessToken
  }

  public func clearToken() throws {
    try storage.delete(key: tokenKey)
    try storage.delete(key: tokenExpiryKey)
    try storage.delete(key: refreshTokenKey)
  }
}

public struct AuthInterceptor: RequestInterceptor {

  public let authenticator: Authenticator

  public init(authenticator: Authenticator) {
    self.authenticator = authenticator
  }

  public func adapt(_ request: URLRequest) async throws -> URLRequest {
    var request = request
    if let token = await authenticator.currentToken() {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return request
  }

  public func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool {
    response.statusCode == 401
  }
}
