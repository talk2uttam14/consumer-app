import Foundation

protocol DependencyContainer {
  var apiManager: APIServiceProtocol { get }
  var authenticator: Authenticator { get }
  var userRepository: UserRepositoryProtocol { get }
}

final class DIContainer: DependencyContainer {

  static let shared = DIContainer()

  let authenticator: Authenticator
  let apiManager: APIServiceProtocol
  private(set) var userRepository: UserRepositoryProtocol

  private init(userRepository: UserRepositoryProtocol? = nil) {
    let authenticator = Authenticator()
    let manager = APIManager(authenticator: authenticator)

    self.authenticator = authenticator
    self.apiManager = manager
    self.userRepository = userRepository ?? UserRepositoryImplementation(
      apiService: manager,
      authenticator: authenticator
    )

    Task { await manager.configureTokenRefresh() }
  }

  func setUserRepository(_ repository: UserRepositoryProtocol) {
    userRepository = repository
  }
}
