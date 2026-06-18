//
//  APIManager.swift
//  consumer-app
//
//  Central HTTP client. All API calls go through here.
//

import Foundation

actor APIManager: APIServiceProtocol {

  let authenticator: Authenticator

  private let session: URLSession = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = NetworkConstants.requestTimeout
    config.timeoutIntervalForResource = 60
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.httpShouldSetCookies = true
    config.waitsForConnectivity = true
    config.allowsConstrainedNetworkAccess = true
    return URLSession(configuration: config)
  }()

  private let decoder = JSONDecoder()
  private lazy var authInterceptor = AuthInterceptor(authenticator: authenticator)
  private lazy var securityInterceptor = BlueMarbleSecurityInterceptor(authenticator: authenticator)

  init(authenticator: Authenticator) {
    self.authenticator = authenticator
  }

  func configureTokenRefresh() async {
    await authenticator.setRefreshHandler { [weak self] refreshToken in
      guard let self else { throw AppError.network(.unauthorized) }
      return try await self.refreshAccessToken(refreshToken)
    }
  }

  // MARK: - Public API

  func request<T: Decodable>(_ api: BaseRequestModel) async throws -> T {
    var urlRequest = try buildURLRequest(from: api)

    if api.secured {
      urlRequest = try await securityInterceptor.adapt(urlRequest)
    }

    urlRequest = try await authInterceptor.adapt(urlRequest)
    return try await executeWithRetry(
      request: urlRequest,
      skipTokenRefresh: api.skipTokenRefresh
    )
  }

  // MARK: - Token Refresh

  private func refreshAccessToken(_ refreshToken: String) async throws -> TokenRefreshResult {
    let api = RefreshTokenAPI(refreshToken: refreshToken)
    var urlRequest = try buildURLRequest(from: api)

    if api.secured {
      urlRequest = try await securityInterceptor.adapt(urlRequest)
    }

    let response: LoginResponse = try await executeWithRetry(
      request: urlRequest,
      skipTokenRefresh: true
    )

    guard let accessToken = response.payload?.accessToken, !accessToken.isEmpty else {
      throw AppError.network(.unauthorized)
    }

    return TokenRefreshResult(
      accessToken: accessToken,
      refreshToken: response.payload?.refreshToken,
      expiresIn: NetworkConstants.defaultTokenExpiresIn
    )
  }

  // MARK: - Request Builder

  private func buildURLRequest(from api: BaseRequestModel) throws -> URLRequest {
    guard let url = api.url else {
      throw NetworkErrorLogger.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = api.method.rawValue
    request.timeoutInterval = api.timeoutInterval

    if let body = api.body {
      request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
    }

    request.allHTTPHeaderFields = api.headers
    logRequest(api.method, url: url, body: request.httpBody)
    return request
  }

  // MARK: - Execute

  private func executeWithRetry<T: Decodable>(
    request: URLRequest,
    skipTokenRefresh: Bool,
    retryCount: Int = 0
  ) async throws -> T {
    guard await NetworkMonitor.shared.isConnected else {
      throw NetworkErrorLogger.noInternetConnection
    }

    try Task.checkCancellation()

    let (data, response) = try await session.data(for: request)
    try Task.checkCancellation()

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkErrorLogger.invalidResponse
    }

    if !skipTokenRefresh,
       await authInterceptor.shouldRetry(response: httpResponse, data: data),
       retryCount < 1 {
      _ = try await authenticator.refreshTokenIfNeeded()
      let newRequest = try await authInterceptor.adapt(request)
      return try await executeWithRetry(
        request: newRequest,
        skipTokenRefresh: skipTokenRefresh,
        retryCount: retryCount + 1
      )
    }

    try validate(httpResponse)

    guard !data.isEmpty else {
      throw NetworkErrorLogger.noDataError
    }

    logResponse(data)
    return try decode(data)
  }

  // MARK: - Decode

  private func decode<T: Decodable>(_ data: Data) throws -> T {
    if let wrapped = try? decoder.decode(APIResponse<T>.self, from: data) {
      return try validateBusinessResponse(wrapped.payload)
    }

    if let errorResp = try? decoder.decode(APIResponse<ErrorResponseModel>.self, from: data) {
      throw AppError.apiError(
        code: errorResp.errorCode,
        message: errorResp.message,
        reason: errorResp.payload.reason
      )
    }

    do {
      let result = try decoder.decode(T.self, from: data)
      return try validateBusinessResponse(result)
    } catch let error as AppError {
      throw error
    } catch {
      throw NetworkErrorLogger.decodingError(error)
    }
  }

  private func validateBusinessResponse<T>(_ response: T) throws -> T {
    if let blueMarbleResponse = response as? BlueMarbleResponse {
      try blueMarbleResponse.validate()
    }
    return response
  }

  // MARK: - HTTP Status Validation

  private func validate(_ response: HTTPURLResponse) throws {
    switch response.statusCode {
    case 200...299: return
    case 401: throw NetworkErrorLogger.unauthorized
    case 408: throw NetworkErrorLogger.timeout
    case 400...499: throw NetworkErrorLogger.clientError(code: response.statusCode)
    case 500...599: throw NetworkErrorLogger.serverError(code: response.statusCode)
    default: throw NetworkErrorLogger.invalidResponse
    }
  }

  // MARK: - Logging

  private func logRequest(_ method: HTTPMethod, url: URL, body: Data?) {
    LogUtils.print("\(method.rawValue) | \(url.absoluteString)")
    if let body, let bodyString = String(data: body, encoding: .utf8) {
      LogUtils.print("Request Body:")
      NetworkLogger.printPrettyJson(bodyString)
    }
  }

  private func logResponse(_ data: Data) {
    if let jsonString = String(data: data, encoding: .utf8) {
      LogUtils.print("Response:")
      NetworkLogger.printPrettyJson(jsonString)
    }
  }
}
