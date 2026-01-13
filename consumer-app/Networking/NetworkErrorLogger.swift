//
//  NetworkErrors.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

enum NetworkErrorLogger: Error {
    static let domain = "NetworkError"

    case noInternetConnection
    case invalidURL
    case invalidResponse
    case unauthorized
    case clientError(code: Int)
    case serverError(code: Int)
    case noDataError
    case decodingError(Error)

    var localizedDescription: String {
        switch self {
        case .noInternetConnection: return "No internet connection"
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .unauthorized: return "Unauthorized"
        case .clientError(let code): return "Client error \(code)"
        case .serverError(let code): return "Server error \(code)"
        case .noDataError: return "No data"
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        }
    }
}