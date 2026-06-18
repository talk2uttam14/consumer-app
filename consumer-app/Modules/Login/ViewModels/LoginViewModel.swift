import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {

  var mobile = ""
  var pin = ""
  var isLoading = false
  var isLoggedIn = false
  var error: AppError?

  private let repository: UserRepositoryProtocol

  init(repository: UserRepositoryProtocol? = nil) {
    self.repository = repository ?? DIContainer.shared.userRepository
  }

  func login() async {
    isLoading = true
    error = nil
    defer { isLoading = false }

    do {
      try await repository.login(mobile: mobile, pin: pin)
      isLoggedIn = true
    } catch {
      let appError = ErrorHandler.mapToAppError(error)
      ErrorHandler.logError(appError)
      isLoggedIn = false
      pin = ""
      if appError.isUnauthorized || appError.isAccountLocked {
        mobile = ""
      }
      self.error = appError
    }
  }
}
