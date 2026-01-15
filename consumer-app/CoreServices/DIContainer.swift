import Foundation

// MARK: - Dependency Container Protocol
protocol DependencyContainer {
    var apiManager: APIServiceProtocol { get }
    var userRepository: UserRepositoryProtocol { get }
}

final class DIContainer: DependencyContainer {
    static let shared = DIContainer()
    
    // MARK: - Services
    let apiManager: APIServiceProtocol
    
    // MARK: - Repositories
    private(set) var userRepository: UserRepositoryProtocol
    
    // MARK: - Initializer
    private init(userRepository: UserRepositoryProtocol? = nil) {
        // Initialize apiManager first
        self.apiManager = APIManager.shared
        
        // Then initialize userRepository
        self.userRepository = userRepository ?? UserRepository(apiService: self.apiManager)
    }
    
    // MARK: - For Testing
    func setUserRepository(_ repository: UserRepositoryProtocol) {
        self.userRepository = repository
    }
}
