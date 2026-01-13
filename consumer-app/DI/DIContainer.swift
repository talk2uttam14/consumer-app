//import Foundation
//
//final class DIContainer {
//    static let shared = DIContainer()
//    private init() {}
//
//    private var factories: [String: () -> Any] = [:]
//    private let lock = NSLock()
//
//    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
//        lock.lock(); defer { lock.unlock() }
//        factories[String(describing: type)] = factory
//    }
//
//    func resolve<T>(_ type: T.Type) -> T {
//        lock.lock(); defer { lock.unlock() }
//        let key = String(describing: type)
//        guard let factory = factories[key], let value = factory() as? T else {
//            fatalError("No registration for \(key)")
//        }
//        return value
//    }
//
//    func clearAll() {
//        lock.lock(); defer { lock.unlock() }
//        factories.removeAll()
//    }
//}
