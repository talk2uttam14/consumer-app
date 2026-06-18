//
//  BlueMarbleSecurityInterceptor.swift
//  consumer-app
//
//  Adds BlueMarble security headers before each secured request.
//  Used automatically when BaseRequestModel has secured: true.
//

import Foundation

struct BlueMarbleSecurityInterceptor: RequestInterceptor {

  private let headerProvider: BlueMarbleSecurityHeaderProviding
  private let authenticator: Authenticator

  init(
    headerProvider: BlueMarbleSecurityHeaderProviding = BlueMarbleSecurityHeaderProvider(),
    authenticator: Authenticator
  ) {
    self.headerProvider = headerProvider
    self.authenticator = authenticator
  }

  func adapt(_ request: URLRequest) async throws -> URLRequest {
    var adaptedRequest = request
    let bearerToken = await authenticator.currentToken()
    let headers = headerProvider.makeHeaders(for: adaptedRequest, bearerToken: bearerToken)

    headers.asHTTPHeaderFields.forEach { key, value in
      adaptedRequest.setValue(value, forHTTPHeaderField: key)
    }

    return adaptedRequest
  }

  func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool {
    false
  }
}
