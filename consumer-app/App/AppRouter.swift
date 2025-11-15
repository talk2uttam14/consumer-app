//
//  AppRouter.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//
import SwiftUI
import Combine


// MARK: - Router (ObservableObject)
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    // Singleton or inject via EnvironmentObject
    static let shared = AppRouter()
    
    // MARK: - Navigation
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    // MARK: - Replace (for flows)
    func replace(with route: AppRoute) {
        popToRoot()
        push(route)
    }
}
