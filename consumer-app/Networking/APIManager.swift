//
//  UserRepository.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//

import Foundation

actor APIManager: APIServiceProtocol {

    static let shared = APIManager()
    private init() {}

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpShouldSetCookies = true
        config.waitsForConnectivity = true
        config.allowsConstrainedNetworkAccess = true
        return URLSession(configuration: config)
    }()

    private let decoder = JSONDecoder()
    private let authenticator = Authenticator()
    private lazy var interceptor = AuthInterceptor(authenticator: authenticator)

    // MARK: - Public async request
    func request<T: Decodable>(_ route: APIRoute) async throws -> T {
        var urlRequest = try buildURLRequest(from: route.request)
        urlRequest = try await interceptor.adapt(urlRequest)
        return try await executeWithRetry(request: urlRequest)
    }

    // MARK: - Build URLRequest
    private func buildURLRequest(from apiRequest: APIRequest) throws -> URLRequest {
        guard var components = URLComponents(string: EnvironmentConstants.baseURLString + apiRequest.path) else {
            throw NetworkErrorLogger.invalidURL
        }

        if let query = apiRequest.query {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else { throw NetworkErrorLogger.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        request.timeoutInterval = apiRequest.timeout

        if let body = apiRequest.body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        request.allHTTPHeaderFields = apiRequest.headers.merging(
            BaseRequestModel().headers,
            uniquingKeysWith: { $1 }
        )

        // Logging
        LogUtils.print("\(apiRequest.method.rawValue) | Endpoint URL: \(url.absoluteString)")
        NetworkLogger.printPrettyHeaders(from: request)
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            LogUtils.print("Request Body: -")
            NetworkLogger.printPrettyJson(bodyString)
        }

        return request
    }


    // MARK: - Execute request with retry on 401
    private func executeWithRetry<T: Decodable>(request: URLRequest, retryCount: Int = 0) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            throw NetworkErrorLogger.noInternetConnection
        }
        try Task.checkCancellation()
        let (data, response) = try await session.data(for: request, delegate: nil)
        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrorLogger.invalidResponse
        }

        // Retry if 401
        if await interceptor.shouldRetry(response: httpResponse, data: data),
           retryCount < 1 {
            _ = try await authenticator.refreshTokenIfNeeded()
            let newRequest = try await interceptor.adapt(request)
            return try await executeWithRetry(request: newRequest, retryCount: retryCount + 1)
        }

        try Task.checkCancellation()
        try validate(httpResponse)

        guard !data.isEmpty else {
            throw NetworkErrorLogger.noDataError
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            LogUtils.print("Response : -")
            NetworkLogger.printPrettyJson(jsonString)
        }

        return try await decodeOnBackground(data)
    }

    // MARK: - Decode response
    /// Decodes JSON data on background thread to avoid blocking main thread
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        // Attempt to decode APIResponse wrapper first if expected
        if let wrapped = try? decoder.decode(APIResponse<T>.self, from: data) {
            return wrapped.payload
        }
        
        // Attempt to decode Error Response
        if let errorResp = try? decoder.decode(APIResponse<ErrorResponseModel>.self, from: data) {
            throw NSError(
                domain: "APIError",
                code: errorResp.errorCode,
                userInfo: [
                    "reason": errorResp.payload.reason ?? "",
                    "message": errorResp.message
                ]
            )
        }

        // Fallback to direct decoding or throw specific error
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
             throw NetworkErrorLogger.decodingError(error)
        }
    }
    
    // MARK: - Decode on Background Thread
    /// For large payloads, decode on background thread explicitly
    private func decodeOnBackground<T: Decodable>(_ data: Data) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let value: T = try self.decode(data)
                    continuation.resume(returning: value)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }


    // MARK: - Validate HTTP response
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
}
