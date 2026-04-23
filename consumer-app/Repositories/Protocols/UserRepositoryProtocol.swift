
import Foundation

public protocol UserRepositoryProtocol {
    func fetchLanguages() async throws -> GetLanguageResponse // Step 3: this is the abstraction done here a
}
