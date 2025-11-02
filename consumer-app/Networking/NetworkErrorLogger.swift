//
//  NetworkErrors.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

enum NetworkErrorLogger: Error, LocalizedError {
    case noInternetConnection
    case invalidURL
    case requestFailed
    case noDataError
    case invalidResponse
    case unauthorized
    case clientError(code: Int)
    case serverError(code: Int)
    case decodingError(Error)
    case unknown(Error)
    var errorDescription: String {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed:
            return "Request Failed"
        case .noDataError:
            return "No Data Found"
        case .invalidResponse:
            return "Invalid server response."
        case .unauthorized:
            return "Unauthorized. Please log in again."
        case .clientError(let code):
            return "A client error occurred (\(code)). Please check your input and try again."
        case .serverError(let code):
            return "Server error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred. \(error.localizedDescription)"
        }
    }
}
