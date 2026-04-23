//
//  AppEnvironment.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

public enum EnvironmentType {
    case uat
    case prod
}
public struct EnvironmentConstants {
    public static let currentEnvType: EnvironmentType = .uat
    public static var baseURLString: String {
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
    public static var baseURL: URL? {
        return URL(string: baseURLString)
    }
}
