//
//  APIRoute.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


import Foundation

enum APIRoute {

    // GET APIs
    case get(path: String, query: [String: String]? = nil)

    // POST APIs
    case post(path: String, body: Encodable? = nil)

    // PUT APIs
    case put(path: String, body: Encodable? = nil)

    // DELETE APIs
    case delete(path: String, query: [String: String]? = nil)

    /// Convert to APIRequest
    var request: APIRequest {
        switch self {
        case .get(let path, let query):
            return APIRequest(path: path, method: .get, query: query)
        case .post(let path, let body):
            return APIRequest(path: path, method: .post, body: body)
        case .put(let path, let body):
            return APIRequest(path: path, method: .put, body: body)
        case .delete(let path, let query):
            return APIRequest(path: path, method: .delete, query: query)
        }
    }
}

struct APIRequest {
    let path: String
    let method: HTTPMethod
    var query: [String: String]? = nil
    var body: Encodable? = nil
    var headers: [String: String] = [:]
    var timeout: TimeInterval = 30
}
