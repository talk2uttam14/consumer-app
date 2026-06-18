//
//  TransferAPI.swift
//  consumer-app
//

import Foundation

final class TransferAPI: BaseRequestModel {
  init(body: TransferRequest, referenceId: String? = nil) {
    super.init()
    endPoint = EndpointConstants.postEndpoints.transfer
    method = .post
    self.body = body
    if let referenceId {
      requestParams = ["referenceId": referenceId]
    }
  }
}
