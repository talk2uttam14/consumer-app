//
//  LanguagesAPI.swift
//  consumer-app
//

import Foundation

/// GET FAQ languages — shared by Home and Login.
final class LanguagesAPI: BaseRequestModel {
  override init() {
    super.init()
    endPoint = EndpointConstants.getEndpoints.getLanguages
    method = .get
    secured = false
  }
}
