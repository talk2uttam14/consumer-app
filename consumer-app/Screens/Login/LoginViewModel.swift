//
//  LoginViewModel.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var mobileNumber: String = ""
    @Published var pin: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiManager = APIManager.shared
    
    func login() {
        isLoading = true
        // Implement login logic
    }
}
