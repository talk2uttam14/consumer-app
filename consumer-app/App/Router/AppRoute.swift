//
//  AppRoute.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

// MARK: - AppRoute.swift
import Foundation

// A Route represents a screen in the app.
// Any route must be storable in navigation stack
protocol Route: Hashable {}

/// App-level routes.
/// This enum decides which feature we are navigating to.
enum AppRoute: Route {
    case home(HomeRoute)
    case profile(ProfileRoute)
    case login(LoginRoute)
}

enum HomeRoute: Route {
    case home
    case dashboard
}

enum LoginRoute: Route {
    case loginPinScreen
    case loginWithMobileAndPin(mobile: String, pin: String)
}

// MARK: - ProfileRoute.swift
enum ProfileRoute: Route {
    case settings
    case editProfile(userId: String)
}
