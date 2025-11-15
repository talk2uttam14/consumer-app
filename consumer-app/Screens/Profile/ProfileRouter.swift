//
//  ProfileRouter.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

import SwiftUI
// MARK: - ProfileRouter.swift
final class ProfileRouter {
    private let appRouter: AppRouter

    init(appRouter: AppRouter = .shared) {
        self.appRouter = appRouter
    }

    func openSettings() {
        appRouter.push(.profile(.settings))
    }

    func openEditProfile(userId: String) {
        appRouter.push(.profile(.editProfile(userId: userId)))
    }
}
// MARK: - ProfileDestination.swift
@ViewBuilder
func ProfileDestination(route: ProfileRoute) -> some View {
    switch route {
    case .settings:
        LoginView()
    case .editProfile(userId: _):
        LoginView()
    }
}
