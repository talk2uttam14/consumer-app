//
//  LoginAPI.swift
//  consumer-app
//

import Foundation

final class LoginAPI: BaseRequestModel {
  init(mobile: String, pin: String) {
    super.init()
    endPoint = EndpointConstants.postEndpoints.login
    method = .post
    body = LoginRequest(mobile: mobile, pin: pin)
  }
}
