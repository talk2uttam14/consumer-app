//
//  UserRepositoryImplementation.swift
//  consumer-app
//

import Foundation

final class UserRepositoryImplementation: UserRepositoryProtocol {

  private let apiService: APIServiceProtocol
  private let authenticator: Authenticator
  private let sessionManager: SessionManaging

  init(
    apiService: APIServiceProtocol,
    authenticator: Authenticator,
    sessionManager: SessionManaging = SessionManager.shared
  ) {
    self.apiService = apiService
    self.authenticator = authenticator
    self.sessionManager = sessionManager
  }

  func fetchHomeLanguages() async throws -> HomeDataUIModel {
    let response: GetLanguageResponse = try await apiService.request(LanguagesAPI())
    return response.toHomeDataUIModel()
  }

  func fetchTenantParameters(term: String) async throws -> [TenantIdDataUIModel] {
    let response: TenantIdListResponse = try await apiService.request(TenantListAPI(term: term))
    return response.toUiModels()
  }

  func saveSelectedTenant(_ tenant: TenantIdDataUIModel) throws {
    try sessionManager.saveSelectedTenant(tenant)
  }

  func getSelectedTenantId() -> String? {
    sessionManager.getSelectedTenantId()
  }

  func login(mobile: String, pin: String) async throws {
    let response: LoginResponse = try await apiService.request(
      LoginAPI(mobile: mobile, pin: pin)
    )

    guard let accessToken = response.payload?.accessToken, !accessToken.isEmpty else {
      throw AppError.unknown(response.message)
    }

    try await authenticator.saveLoginSession(
      accessToken: accessToken,
      refreshToken: response.payload?.refreshToken,
      mobile: mobile
    )
    try sessionManager.saveUserMobile(mobile)
  }
}
