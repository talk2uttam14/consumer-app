import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    var mobileNumber: String = ""
    var pin: String = ""
    var isLoading: Bool = false
    var language: HomeDataUiModel?
    var error: AppError?
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol? = nil) {
        self.repository = repository ?? DIContainer.shared.userRepository
    }

    // MARK: - Load Languages
    func loadLanguages() async {
        isLoading = true
        defer { isLoading = false }  // ✅ automatically resets loading at the end

        error = nil

        do {
            let result = try await repository.fetchLanguages()

            // ✅ Map API model → UI model safely
            let innerData = (result.data ?? []).map { item in
                HomeInnerDataUiModel(
                    ans: item.ans ?? "",
                    ques: item.ques ?? ""
                )
            }

            self.language = HomeDataUiModel(data: innerData)
        } catch {
            let appError = ErrorHandler.mapToAppError(error)
            ErrorHandler.logError(appError)
            self.error = appError
        }
    }

}
