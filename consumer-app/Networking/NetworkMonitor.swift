//
//  NetworkMonitor.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 01/11/25.
//

import Network
import Observation
@Observable
public final class NetworkMonitor {
    public static let shared = NetworkMonitor()
    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor.Queue")
    public var isConnected: Bool = false

    private init() {}

    public func startMonitoring() {
        pathMonitor.start(queue: monitorQueue)
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                debugPrint("Network status: \(self.isConnected ? "Connected" : "Disconnected")")
            }
        }
    }
}
