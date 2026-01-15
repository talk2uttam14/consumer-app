//
//  UserRepository.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//

import Foundation

public protocol RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest
    func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool
}

public actor Authenticator {
    private var token: String?
    private var refreshTask: Task<String, Error>?

    public init() {}

    public func currentToken() -> String? { token }
    public func setToken(_ t: String) { token = t }

    public func refreshTokenIfNeeded() async throws -> String {
        if let t = token { return t } // replace with expiry check
        if let task = refreshTask { return try await task.value }
        refreshTask = Task {
            try await Task.sleep(nanoseconds: 200 * 1_000_000) // placeholder
            let newToken = "refreshed-token"
            token = newToken
            return newToken
        }
        defer { refreshTask = nil }
        return try await refreshTask!.value
    }
}

public struct AuthInterceptor: RequestInterceptor {
    public let authenticator: Authenticator
    
    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
    }
    
    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var r = request
        if let t = await authenticator.currentToken() {
            r.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
        }
        return r
    }
    public func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool {
        response.statusCode == 401
    }
}
