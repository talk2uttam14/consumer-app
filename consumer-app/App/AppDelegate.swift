//
//  AppDelegate.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 03/11/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // Called when app finishes launching
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        print("✅ AppDelegate: didFinishLaunchingWithOptions called")
        NetworkMonitor.shared.startMonitoring()
        LogUtils.setLoggingEnabled(isEnabled: true)
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("📱 AppDelegate: App moved to background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("🌅 AppDelegate: App will enter foreground")
    }
    // Example: Handling push notification registration
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("📩 Push token: \(deviceToken)")
    }
}
