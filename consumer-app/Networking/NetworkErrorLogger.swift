//
//  NetworkErrors.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

enum NetworkErrorLogger: LocalizedError {
    case noInternetConnection
    case invalidURL
    case invalidResponse
    case noDataError
    case decodingError(Error)
    case requestFailed
    case unauthorized
    case clientError(code: Int)
    case serverError(code: Int)

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection. Check your network and try again."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .noDataError:
            return "No data received from server."
        case .decodingError(let err):
            return "Failed to decode response: \(err.localizedDescription)"
        case .requestFailed:
            return "Request failed. Please try again."
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .clientError(let code):
            return "Client error (\(code))."
        case .serverError(let code):
            return "Server error (\(code))."
        }
    }
}
