
//
//  LoginMobileWithPinView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 12/02/26.
//

import SwiftUI

    @MainActor
    @Observable
final class LoginMobileWithPinViewModel {
    public var loggedInMobileNumber: String = String.empty
    var isFirstTimeLogin: Bool = true
    var error: AppError?
    var language: LanguageDataUIModel?
    var userData: UserData?
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol? = nil, isFirstTimeLogin: Bool = true) {
        self.repository = repository ?? DIContainer.shared.userRepository
    }
    func fetchLanguage() async {
        do {
            let languageResp = try await self.repository.fetchLanguages()
            let languageItems = languageResp.data?.map { item in
                LanguageInnerUIModel(question: item.ques ?? String.empty, answers: item.ans ?? String.empty)
            } ?? []
            language = LanguageDataUIModel(languageList: languageItems)
        } catch {
            let appError = AppError(error: error)
            self.error = appError
        }
    }
    func getUserData() async {
        do {
            let urlString = String("https://api.github.com/users/talk2uttam14")
            let url = URL(string: urlString)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                throw NetworkError.invalidResponse
            }
            userData = try JSONDecoder().decode(UserData.self, from: data)
        } catch {
            let appError = AppError(error: error)
            self.error = appError
        }
    }
    
}
