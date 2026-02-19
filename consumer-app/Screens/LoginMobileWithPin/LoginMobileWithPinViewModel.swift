
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
    var isFirstTimeLogin: Bool = true
    var error: AppError?
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol? = nil, isFirstTimeLogin: Bool = true) {
        self.repository = repository ?? DIContainer.shared.userRepository
    }
    
}
