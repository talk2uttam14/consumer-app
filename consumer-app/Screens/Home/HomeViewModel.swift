//
//  HomeViewModel.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    var mobileNumber: String = ""
    var pin: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var language: GetLanguageResponse?

    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol? = nil) {
        self.repository = repository ?? DIContainer.shared.userRepository
    }

    func loadLanguages() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                language = try await repository.fetchLanguages()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
