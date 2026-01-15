//
//  APIServiceProtocol.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


import Foundation

protocol APIServiceProtocol {
    func request<T: Decodable>(_ route: APIRoute) async throws -> T
}
