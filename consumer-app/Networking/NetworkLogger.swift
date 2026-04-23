//
//  NetworkLogger.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation
public final class NetworkLogger {
    public static func printPrettyJson(_ jsonString: String?) {
        if let jsonString = jsonString, let data = jsonString.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    LogUtils.print(prettyString)
                }
            } catch {
                LogUtils.print("Error serializing JSON: \(error.localizedDescription)")
            }
        } else {
            LogUtils.print("Failed to convert JSON string to Data.")
        }
    }
    /// Prints request headers in a pretty format
    public static func printPrettyHeaders(from request: URLRequest) {
        LogUtils.print("Request Headers: -")
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                LogUtils.print("\(key): \(value)")
            }
        }
    }
}

