//
//  MockUserRepositoryImplementation.swift
//  consumer-app
//

import Foundation

final class MockUserRepositoryImplementation: UserRepositoryProtocol {

  private let mockLanguageResponse = GetLanguageResponse(
    data: [
      LanguageItem(ans: "A1", ques: "Q1"),
      LanguageItem(ans: "A2", ques: "Q2")
    ]
  )

  func fetchHomeLanguages() async throws -> HomeDataUIModel {
    mockLanguageResponse.toHomeDataUIModel()
  }

  func fetchTenantParameters(term: String) async throws -> [TenantIdDataUIModel] {
    [
      TenantIdDataUIModel(
        payload: TenantListPayload(
          id: TenantIDPayload(mod1ModId: "MOD1", mdlParameterId: "PARAM1"),
          mdlParameterValue: term,
          mdlParamDescription: "Mock Tenant for \(term)",
          mdlUserId: nil
        )
      )
    ]
  }

  func saveSelectedTenant(_ tenant: TenantIdDataUIModel) throws {}

  func getSelectedTenantId() -> String? { "mock-tenant" }

  func login(mobile: String, pin: String) async throws {}
}
