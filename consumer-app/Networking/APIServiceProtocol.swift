//
//  APIServiceProtocol.swift
//  consumer-app
//

import Foundation

protocol APIServiceProtocol {
  func request<T: Decodable>(_ api: BaseRequestModel) async throws -> T
}
