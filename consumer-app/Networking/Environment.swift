import Foundation
import Combine

enum APIEnvironment: String, CaseIterable {
    case uat, prod

    var baseURL: String {
        switch self {
        case .uat: return "https://api-uat.example.com"
        case .prod: return NetworkConstants.baseUrl
        }
    }
}

protocol AppConfig {
    var currentEnvironment: APIEnvironment { get }
    var environmentPublisher: AnyPublisher<APIEnvironment, Never> { get }
    func setEnvironment(_ env: APIEnvironment)
}

final class AppConfigImpl: AppConfig {
    @Published private(set) var currentEnvironment: APIEnvironment
    init(initial: APIEnvironment = .prod) { currentEnvironment = initial }
    var environmentPublisher: AnyPublisher<APIEnvironment, Never> { $currentEnvironment.eraseToAnyPublisher() }
    func setEnvironment(_ env: APIEnvironment) { currentEnvironment = env }
}