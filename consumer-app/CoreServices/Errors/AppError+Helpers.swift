//
//  AppError+Helpers.swift
//  consumer-app
//
//  Quick checks for onError handlers in ViewModels.
//

import Foundation

extension AppError {

  var isUnauthorized: Bool {
    if case .network(.unauthorized) = self { return true }
    return false
  }

  var isInvalidPin: Bool {
    if case .validation(.invalidPin) = self { return true }
    return false
  }

  var isNoInternet: Bool {
    if case .network(.noInternetConnection) = self { return true }
    return false
  }

  var isAccountLocked: Bool {
    if case .business(.accountLocked) = self { return true }
    return false
  }

  var isTooManyAttempts: Bool {
    if case .security(.tooManyAttempts) = self { return true }
    return false
  }
}

extension AppError {

  static func apiError(code: Int, message: String, reason: String? = nil) -> AppError {
    ErrorHandler.mapToAppError(
      NSError(
        domain: "APIError",
        code: code,
        userInfo: [
          "message": message,
          "reason": reason ?? ""
        ]
      )
    )
  }
}
