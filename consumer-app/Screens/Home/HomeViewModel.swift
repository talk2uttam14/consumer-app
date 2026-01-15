import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    var mobileNumber: String = ""
    var pin: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var language: GetLanguageResponse?

    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol? = nil) {
        self.repository = repository ?? DIContainer.shared.userRepository
    }

    // MARK: - Load Languages
    func loadLanguages() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await repository.fetchLanguages()
            self.language = result
            self.isLoading = false

        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
