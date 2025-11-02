//
//  BaseRequestModel.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 30/10/25.
//
import Foundation

class BaseRequestModel {
    var endPoint: String = String.empty
    var timeoutInterval: Double = 30
    var method: HTTPMethod = .post
    var body: Encodable?
    var retryCount: Int = 0
    var requestParameters: [String: String]? = nil
    var additionalHeaders: [String: String] = [:]
    var url: URL? {
        let baseUrl = EnvironmentConstants.baseURLString
        let trimmedEndpoint = endPoint.trimmingCharacters(in: .whitespacesAndNewlines)
        var fullPath = String.empty
        if trimmedEndpoint.lowercased().hasPrefix("http") {
            fullPath = trimmedEndpoint
        } else {
            let slash = (baseUrl.hasSuffix("/") || trimmedEndpoint.hasPrefix("/")) ? "" : "/"
            fullPath = baseUrl + slash + trimmedEndpoint
        }
        var urlComponents = URLComponents(string: fullPath)
        var queryItems = urlComponents?.queryItems ?? []

        if let params = requestParameters, !params.isEmpty {
            for (key, value) in params where !value.isEmpty {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            return urlComponents?.url
        }
        
        return URL(string: fullPath)
    }
    private var baseHeaders: [String: String] {
        let headers: [String: String] =
        [
            "Authorization": "Berer guiybgjhghjg",
            "Content-Type": "application/json;charset=UTF-8",
            "Referer": "https://lms-5x.mobilytix.net/"
        ]
        return headers.filter { !$0.value.isEmpty }
    }
    var headers: [String: String] {
        let combined = baseHeaders.merging(additionalHeaders) { _, new in new }
        return combined.filter { !$0.value.isEmpty }
    }
    
}

/// Flexible Encoder for any Encodable type required in request body
struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    init<T: Encodable>(_ value: T) {
        self.encodeFunc = value.encode
    }
    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
/// API Response Wrapper for generic payloads
struct APIResponse<T: Codable>: Codable {
    let errorCode: Int
    let success: Bool
    let refreshToken: Bool
    let message: String
    let payload: T
}

/// common error response model for structured API errors
struct ErrorResponseModel: Codable {
    let errorCode: Int?
    let success: Bool?
    let refreshToken: Bool?
    let message: String?
    let reason: String?
    enum CodingKeys: String, CodingKey {
        case errorCode
        case success
        case refreshToken
        case message
        case reason
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorCode = try container.decodeIfPresent(Int.self, forKey: .errorCode)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
        self.refreshToken = try container.decodeIfPresent(Bool.self, forKey: .refreshToken)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }
}

