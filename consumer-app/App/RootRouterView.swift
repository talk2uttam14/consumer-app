//
//  RootRouterView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

// MARK: - RootView.swift
import SwiftUI

struct RootRouterView: View {
    @StateObject private var appRouter = AppRouter.shared

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .profile(let profileRoute):
                        ProfileDestination(route: profileRoute)
                    case .login:
                        HomeView()
                    case .success(message: let message):
                        HomeView()
                    case .payments(_):
                        HomeView()
                    }
                }
        }
        .environmentObject(appRouter)
    }
}
