//
//  LandingViewModel.swift
//  consumer-app
//

import Foundation
import Observation

@MainActor
@Observable
final class LandingViewModel {

  var isLoading = false
  var tenants: [TenantIdDataUIModel] = []
  var selectedTenant: TenantIdDataUIModel?
  var error: AppError?

  private let repository: UserRepositoryProtocol

  init(repository: UserRepositoryProtocol? = nil) {
    self.repository = repository ?? DIContainer.shared.userRepository
  }

  func loadTenantParameters() async {
    await loadTenantParameters(term: NetworkConstants.Default.tenantTerm)
  }

  func loadTenantParameters(term: String) async {
    isLoading = true
    error = nil
    defer { isLoading = false }

    do {
      tenants = try await repository.fetchTenantParameters(term: term)
      restoreSelectedTenant()
    } catch {
      let appError = ErrorHandler.mapToAppError(error)
      ErrorHandler.logError(appError)
      handleTenantLoadError(appError)
      self.error = appError
    }
  }

  func selectTenant(_ tenant: TenantIdDataUIModel) {
    selectedTenant = tenant
    try? repository.saveSelectedTenant(tenant)
  }

  func handleLoginTapped(onNavigate: () -> Void) {
    if tenants.isEmpty {
      Task { await loadTenantParameters() }
      return
    }

    if selectedTenant == nil, let firstTenant = tenants.first {
      selectTenant(firstTenant)
    }

    onNavigate()
  }

  private func restoreSelectedTenant() {
    guard let savedTenantId = repository.getSelectedTenantId() else { return }
    selectedTenant = tenants.first { $0.tenantId == savedTenantId }
  }

  private func handleTenantLoadError(_ appError: AppError) {
    tenants = []
    selectedTenant = nil
  }
}
