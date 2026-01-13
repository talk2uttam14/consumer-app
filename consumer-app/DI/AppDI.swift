//import Foundation
//
//enum AppDI {
//    static func setup(initialEnv: APIEnvironment = .prod) {
//        DIContainer.shared.register(APIManagerProtocol.self) { APIManager.shared }
//        DIContainer.shared.register(AppConfig.self) { AppConfigImpl(initial: initialEnv) }
//
//        #if DEBUG
//        DIContainer.shared.register(APIServiceProtocol.self) { MockAPIService() }
//        #else
//        DIContainer.shared.register(APIServiceProtocol.self) {
//            APIService(apiManager: DIContainer.shared.resolve(APIManagerProtocol.self),
//                       appConfig: DIContainer.shared.resolve(AppConfig.self))
//        }
//        #endif
//
//        DIContainer.shared.register(MRAppRepositoryProtocol.self) {
//            MRAppRepository(apiService: DIContainer.shared.resolve(APIServiceProtocol.self))
//        }
//    }
//}
