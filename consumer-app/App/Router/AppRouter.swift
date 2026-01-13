//
//  AppRouter.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//
import SwiftUI

/// AppRouter is the brain of navigation.
/// It stores which screen is currently open.
@MainActor
final class AppRouter: ObservableObject {

    /// Stack-based navigation (push / pop)
    @Published var path = NavigationPath()

    /// Sheet-based navigation (modal)
    @Published var sheet: RouteSheet?

    /// Shared instance (OK for beginners)
    static let shared = AppRouter()

    private init() {}
}

// MARK: - Navigation Actions
extension AppRouter {

    /// Push a new screen
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// Go back one screen
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Go back to first screen
    func popToRoot() {
        path = NavigationPath()
    }

    /// Present a modal sheet
    func presentSheet(_ route: AppRoute) {
        sheet = RouteSheet(route: route)
    }

    /// Dismiss modal sheet
    func dismissSheet() {
        sheet = nil
    }
}
struct RouteSheet: Identifiable {
    let id = UUID()
    let route: AppRoute
}
