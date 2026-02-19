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
    
    var body: some View {
//        NavigationStack(path: $router.path) {
//            HomeView(viewModel: HomeViewModel())
//                .navigationDestination(for: AppRoute.self) { route in
//                    destination(for: route)
//                }
//        }
//        .sheet(item: $router.sheet) { sheet in
//            destination(for: sheet.route)
//        }
        NavigationStack(path: $router.path) {
            LoginMobileWithPinView(loginVM: LoginMobileWithPinViewModel())
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }
    
    /// Converts a route into a screen (View)
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home(let homeRoute):
            homeDestination(homeRoute)
        case .LoginRoute(let loginRoute):
            LoginDestination(loginRoute)
        }
    }
        // MARK: - Feature Destinations
        func homeDestination(_ route: HomeRoute) -> some View {
            switch route {
            case .home:
                HomeView(viewModel: HomeViewModel())
            case .dashboard:
                HomeView(viewModel: HomeViewModel())
            }
        }
        
    func LoginDestination(_ route: LoginRoute) -> some View {
        switch route {
        case .loginPinScreen:
               LoginWithPinView(loginVM: LoginMobileWithPinViewModel())
        case .loginWithMobileAndPin(mobile: let mobile, pin: let pin):
            LoginWithPinView(loginVM: LoginMobileWithPinViewModel(isFirstTimeLogin: true))

        }
    }
    }

