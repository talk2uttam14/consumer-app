//
//  NetworkMonitor.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 01/11/25.
//

import Network
import Combine

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor.Queue")
    @Published private(set) var isConnected:Bool = false

    func startMonitoring() {
        pathMonitor.start(queue: monitorQueue)
        pathMonitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
                debugPrint("Network status: \(self?.isConnected ?? false ? "Connected" : "Disconnected")")
            }
        }
    }
}
