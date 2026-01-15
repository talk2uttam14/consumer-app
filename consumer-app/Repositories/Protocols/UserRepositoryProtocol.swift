
import Foundation

public protocol UserRepositoryProtocol {
    func fetchLanguages() async throws -> GetLanguageResponse
}
