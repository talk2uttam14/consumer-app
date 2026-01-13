import Foundation

protocol RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest
    func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool
}

actor Authenticator {
    private var token: String?
    private var refreshTask: Task<String, Error>?

    func currentToken() -> String? { token }
    func setToken(_ t: String) { token = t }

    func refreshTokenIfNeeded() async throws -> String {
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

struct AuthInterceptor: RequestInterceptor {
    let authenticator: Authenticator
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var r = request
        if let t = await authenticator.currentToken() {
            r.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
        }
        return r
    }
    func shouldRetry(response: HTTPURLResponse, data: Data) async -> Bool {
        response.statusCode == 401
    }
}