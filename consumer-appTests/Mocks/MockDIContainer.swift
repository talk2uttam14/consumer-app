//
//  MockDIContainer.swift
//  consumer-appTests
//
//  Mock dependency container for unit testing
//

import Foundation
@testable import consumer_app

// MARK: - Mock DI Container
final class MockDIContainer: DependencyContainer {
    var apiManager: APIServiceProtocol
    var userRepository: UserRepositoryProtocol
    
    init(
        apiManager: APIServiceProtocol = MockAPIManager(),
        userRepository: UserRepositoryProtocol = MockUserRepository()
    ) {
        self.apiManager = apiManager
        self.userRepository = userRepository
    }
}

// MARK: - Mock API Manager
final class MockAPIManager: APIServiceProtocol {
    var shouldFail: Bool = false
    var mockResponse: Any?
    var mockError: Error?
    
    func request<T: Decodable>(_ route: APIRoute) async throws -> T {
        if shouldFail, let error = mockError {
            throw error
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        throw AppError.network(.invalidResponse)
    }
}

// MARK: - Mock User Repository
final class MockUserRepository: UserRepositoryProtocol {
    var shouldFail: Bool = false
    var mockLanguages: GetLanguageResponse?
    var mockError: Error?
    var fetchLanguagesCalled: Bool = false
    
    // Closure for custom behavior in tests
    var onFetchLanguages: (() async throws -> GetLanguageResponse)?
    
    func fetchLanguages() async throws -> GetLanguageResponse {
        fetchLanguagesCalled = true
        
        // Use custom closure if provided
        if let customBehavior = onFetchLanguages {
            return try await customBehavior()
        }
        
        if shouldFail {
            throw mockError ?? AppError.network(.serverError(500))
        }
        
        return mockLanguages ?? GetLanguageResponse(languages: [])
    }
}
