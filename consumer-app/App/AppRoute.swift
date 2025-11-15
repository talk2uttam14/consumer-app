//
//  AppRoute.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

// MARK: - AppRoute.swift
import Foundation

enum AppRoute: Hashable {
    case home
    case login
    case success(message: String)

    // Delegated feature routes
    case payments(PaymentRoute)
    case profile(ProfileRoute)
}

// MARK: - PaymentRoute.swift
enum PaymentRoute: Hashable {
    case sendMoney(amount: Double)
    case success(transactionId: String)
}

// MARK: - ProfileRoute.swift
enum ProfileRoute: Hashable {
    case settings
    case editProfile(userId: String)
}
