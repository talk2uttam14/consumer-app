import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

  var isLoading = false
  var language: HomeDataUIModel?
  var error: AppError?

  private let repository: UserRepositoryProtocol

  init(repository: UserRepositoryProtocol? = nil) {
    self.repository = repository ?? DIContainer.shared.userRepository
  }

  func loadLanguages() async {
    isLoading = true
    error = nil
    defer { isLoading = false }

    do {
      language = try await repository.fetchHomeLanguages()
    } catch {
      let appError = ErrorHandler.mapToAppError(error)
      ErrorHandler.logError(appError)
      language = nil
      self.error = appError
    }
  }
}
