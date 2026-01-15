//
//  UserRepository.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Fetch Languages (GET)
    func fetchLanguages() async throws -> GetLanguageResponse {
        try await apiService.request(.get(path: EndpointConstants.getEndpoints.getLanguages))
    }
}
