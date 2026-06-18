import Foundation

protocol UserRepositoryProtocol {
  func fetchHomeLanguages() async throws -> HomeDataUIModel
  func fetchTenantParameters(term: String) async throws -> [TenantIdDataUIModel]
  func saveSelectedTenant(_ tenant: TenantIdDataUIModel) throws
  func getSelectedTenantId() -> String?
  func login(mobile: String, pin: String) async throws
}
