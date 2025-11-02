//
//  NetworkLogger.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation
final class NetworkLogger {
     static func printPrettyJson(_ jsonString: String?) {
        if let jsonString = jsonString, let data = jsonString.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    LogUtils.print(prettyString)
                }
            } catch {
                LogUtils.e("Error serializing JSON: \(error.localizedDescription)")
            }
        } else {
            LogUtils.e("Failed to convert JSON string to Data.")
        }
    }
    /// Prints request headers in a pretty format
     static func printPrettyHeaders(from request: URLRequest) {
        LogUtils.i("Request Headers:")
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                LogUtils.print("\(key): \(value)")
            }
        }
    }
}

