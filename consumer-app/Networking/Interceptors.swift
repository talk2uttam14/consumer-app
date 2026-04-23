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
    private let storage = SecureStorage.shared
    private let tokenKey = "auth_token"
    private let tokenExpiryKey = "token_expiry"
    private let refreshTokenKey = "refresh_token"
    
    private var refreshTask: Task<String, Error>?

    public init() {}

    // MARK: - Current Token
    public func currentToken() async -> String? {
        // Check if token is expired
        if await isTokenExpired() {
            return nil
        }
        return try? storage.retrieve(key: tokenKey)
    }
    
    // MARK: - Set Token
    public func setToken(_ token: String, expiresIn: TimeInterval) throws {
        try storage.save(key: tokenKey, value: token)
        let expiryDate = Date().addingTimeInterval(expiresIn)
        try storage.save(key: tokenExpiryKey, value: "\(expiryDate.timeIntervalSince1970)")
    }
    
    // MARK: - Set Refresh Token
    public func setRefreshToken(_ refreshToken: String) throws {
        try storage.save(key: refreshTokenKey, value: refreshToken)
    }
    
    // MARK: - Check Token Expiry
    private func isTokenExpired() async -> Bool {
        guard let expiryString = try? storage.retrieve(key: tokenExpiryKey),
              let expiryTimestamp = Double(expiryString) else {
            return true
        }
        
        let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
        // Add 60 second buffer to refresh before actual expiry
        return Date().addingTimeInterval(60) >= expiryDate
    }

    // MARK: - Refresh Token If Needed
    public func refreshTokenIfNeeded() async throws -> String {
        // If we have a valid token, return it
        if let token = await currentToken() {
            return token
        }
        
        // If refresh is already in progress, wait for it
        if let task = refreshTask {
            return try await task.value
        }
        
        // Start new refresh task
        refreshTask = Task {
            let newToken = try await performTokenRefresh()
            return newToken
        }
        
        defer { refreshTask = nil }
        return try await refreshTask!.value
    }
    
    // MARK: - Perform Token Refresh
    private func performTokenRefresh() async throws -> String {
        guard let refreshToken = try? storage.retrieve(key: refreshTokenKey) else {
            throw AppError.network(.unauthorized)
        }
        dump(refreshToken)
        // TODO: Implement actual API call to refresh token
        // For now, this is a placeholder
        // Example:
        // let response = try await apiService.request(.post(path: "/auth/refresh", body: ["refreshToken": refreshToken]))
        // try setToken(response.accessToken, expiresIn: response.expiresIn)
        // try setRefreshToken(response.refreshToken)
        // return response.accessToken
        
        throw AppError.network(.unauthorized)
    }
    
    // MARK: - Clear Token
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
