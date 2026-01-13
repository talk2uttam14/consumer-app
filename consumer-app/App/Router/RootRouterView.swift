//
//  RootRouterView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

// MARK: - RootView.swift
import SwiftUI

/// RootRouterView owns NavigationStack.
/// All navigation flows pass through here.
struct RootRouterView: View {

    @StateObject private var router = AppRouter.shared

    var body: some View {
        NavigationStack(path: $router.path) {
            ContentView()
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .sheet(item: $router.sheet) { sheet in
            destination(for: sheet.route)
        }
        .environmentObject(router)
    }

    /// Converts a route into a screen (View)
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {

        case .home(let homeRoute):
            homeDestination(homeRoute)

        case .login(let loginRoute):
            loginDestination(loginRoute)

        case .profile(let profileRoute):
            profileDestination(profileRoute)
        }
    }

    // MARK: - Feature Destinations

    private func homeDestination(_ route: HomeRoute) -> some View {
        switch route {
        case .home:
            HomeView()
        case .dashboard:
            HomeView()
        }
    }

    private func loginDestination(_ route: LoginRoute) -> some View {
        switch route {
        case .loginPinScreen:
            LoginView()
        case .loginWithMobileAndPin(mobile: let mobile, pin: let pin):
            LoginView()
        }
    }

    private func profileDestination(_ route: ProfileRoute) -> some View {
        switch route {
        case .settings:
            Profile()
        case .editProfile(userId: let userId):
            Profile()
        }
    }
}
