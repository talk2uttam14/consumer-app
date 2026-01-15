//
//  NetworkErrors.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

public enum NetworkErrorLogger: Error {
    public static let domain = "NetworkError"

    case noInternetConnection
    case invalidURL
    case invalidResponse
    case unauthorized
    case timeout
    case clientError(code: Int)
    case serverError(code: Int)
    case noDataError
    case decodingError(Error)

    public var localizedDescription: String {
        switch self {
        case .noInternetConnection: return "No internet connection"
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .unauthorized: return "Unauthorized"
        case .timeout: return "Request timeout"
        case .clientError(let code): return "Client error \(code)"
        case .serverError(let code): return "Server error \(code)"
        case .noDataError: return "No data"
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        }
    }
    
    // MARK: - Convert to AppError
    public var asAppError: AppError {
        switch self {
        case .noInternetConnection:
            return .network(.noInternetConnection)
        case .timeout:
            return .network(.timeout)
        case .unauthorized:
            return .network(.unauthorized)
        case .serverError(let code):
            return .network(.serverError(code))
        case .invalidURL, .invalidResponse, .noDataError, .decodingError:
            return .network(.invalidResponse)
        case .clientError(let code):
            return .network(.serverError(code))
        }
    }
}