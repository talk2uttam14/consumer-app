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
    
    @State private var router = AppRouter.shared
    @State private var loginVM = LoginMobileWithPinViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if loginVM.isFirstTimeLogin {
                    LoginWithPinView(loginVM: loginVM)
                } else {
                    LoginWithPinView(loginVM: loginVM)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
        .environment(router)
    }
    
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home(let homeRoute):
            homeDestination(homeRoute)
        case .LoginRoute(let loginRoute):
            loginDestination(loginRoute)
        }
    }

    // MARK: - Home Destinations
    @ViewBuilder
    private func homeDestination(_ route: HomeRoute) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: HomeViewModel())
        case .dashboard:
            HomeView(viewModel: HomeViewModel())
        }
    }

    // MARK: - Login Destinations
    @ViewBuilder
    private func loginDestination(_ route: LoginRoute) -> some View {
        switch route {
        case .loginPinScreen:
            LoginWithPinView(loginVM: loginVM)
        case .loginWithMobileAndPin:
            LoginMobileWithPinView(loginVM: loginVM)
        }
    }
}
