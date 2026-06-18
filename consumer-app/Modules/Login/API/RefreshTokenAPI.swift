//
//  RefreshTokenAPI.swift
//  consumer-app
//

import Foundation

final class RefreshTokenAPI: BaseRequestModel {
  init(refreshToken: String) {
    super.init()
    endPoint = EndpointConstants.postEndpoints.refreshToken
    method = .post
    body = RefreshTokenRequest(refreshToken: refreshToken)
    skipTokenRefresh = true
  }
}
