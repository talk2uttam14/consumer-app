//
//  consumer_appApp.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 27/10/25.
//

import SwiftUI

@main
struct consumer_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    @StateObject private var appRouter = AppRouter.shared

    var body: some Scene {
        WindowGroup {
            RootRouterView()
               .environmentObject(appRouter)
        }
    }
}
