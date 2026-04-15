//
//  UserRepository.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


import Foundation

final class UserRepositoryImplementation: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Fetch Languages (GET)
    func fetchLanguages() async throws -> GetLanguageResponse {
        try await apiService.request(.get(path: EndpointConstants.getEndpoints.getLanguages))
    }
}

final class MockUserRepositoryImplementation: UserRepositoryProtocol {
    func fetchLanguages() async throws -> GetLanguageResponse {
        return GetLanguageResponse(
            data: [
                InnerData(ans: "A1", ques: "Q1"),
                InnerData(ans: "A2", ques: "Q2")
            ]
        )
    }
}
