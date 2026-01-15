
import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // Services
    lazy var apiManager: APIServiceProtocol = APIManager.shared
    
    // Repositories
    lazy var userRepository: UserRepositoryProtocol = UserRepository(apiService: apiManager)
    
    // Add other repositories here as needed
}
