//
//  SessionManager.swift
//  consumer-app
//
//  Persists tenant selection, user mobile, and language preference.
//

import Foundation

protocol SessionManaging {
  func saveSelectedTenant(_ tenant: TenantIdDataUIModel) throws
  func getSelectedTenantId() -> String?
  func getSelectedTenantDescription() -> String?
  func saveUserMobile(_ mobile: String) throws
  func getUserMobile() -> String?
  func saveLanguage(_ languageCode: String) throws
  func getLanguage() -> String
}

final class SessionManager: SessionManaging {

  static let shared = SessionManager()

  private let storage = SecureStorage.shared

  private init() {}

  func saveSelectedTenant(_ tenant: TenantIdDataUIModel) throws {
    if let tenantId = tenant.tenantId {
      try storage.save(key: KeyChainConstants.selectedTenantIdKey, value: tenantId)
    }
    if let description = tenant.description {
      try storage.save(key: KeyChainConstants.selectedTenantDescriptionKey, value: description)
    }
  }

  func getSelectedTenantId() -> String? {
    try? storage.retrieve(key: KeyChainConstants.selectedTenantIdKey)
  }

  func getSelectedTenantDescription() -> String? {
    try? storage.retrieve(key: KeyChainConstants.selectedTenantDescriptionKey)
  }

  func saveUserMobile(_ mobile: String) throws {
    try storage.save(key: KeyChainConstants.userMobileKey, value: mobile)
  }

  func getUserMobile() -> String? {
    try? storage.retrieve(key: KeyChainConstants.userMobileKey)
  }

  func saveLanguage(_ languageCode: String) throws {
    try storage.save(key: KeyChainConstants.userLang, value: languageCode)
  }

  func getLanguage() -> String {
    (try? storage.retrieve(key: KeyChainConstants.userLang)) ?? "en"
  }
}
