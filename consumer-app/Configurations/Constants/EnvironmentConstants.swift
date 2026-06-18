//
//  AppEnvironment.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

public enum EnvironmentType: Sendable {
    case dev
    case uat
    case prod
    case mock
}
public struct EnvironmentConstants {
    public static let currentEnvType: EnvironmentType = .mock
    public static var baseURLString: String {
        switch currentEnvType {
        case .dev:
            return "https://bm-retail-baseline.comviva.com/"
        case .uat:
            return "https://uat.globalpay.om/"
        case .prod:
            return "https://api.example.com/"
        case .mock:
            return "http://172.20.1.51:8080/api/host/bluemarble/"
        }
    }

    /// A URL constructed from the current environment's base URL string.
    public static var baseURL: URL? {
        return URL(string: baseURLString)
    }
}
