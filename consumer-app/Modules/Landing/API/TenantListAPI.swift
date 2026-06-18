//
//  TenantListAPI.swift
//  consumer-app
//

import Foundation

/// GET /api/v1/app/master/parameters?term={term}
final class TenantListAPI: BaseRequestModel {
  init(term: String) {
    super.init()
    endPoint = EndpointConstants.getEndpoints.masterParameters
    method = .get
    requestParams = ["term": term]
  }
}
