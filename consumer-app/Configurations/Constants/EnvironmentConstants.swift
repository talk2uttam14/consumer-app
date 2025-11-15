//
//  AppEnvironment.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

enum EnvironmentType {
    case uat
    case prod
}
struct EnvironmentConstants {
    static let currentEnvType: EnvironmentType = .uat
    static var baseURLString: String {
        switch currentEnvType {
        case .uat:
            // Replace with your actual UAT host
            return "https://uat.globalpay.om/"
        case .prod:
            // Replace with your actual Production host
            return "https://api.example.com"
        }
    }

    /// A URL constructed from the current environment's base URL string.
    static var baseURL: URL? {
        return URL(string: baseURLString)
    }
}
