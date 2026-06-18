//
//  TenantListResponseModel.swift
//  consumer-app
//

import Foundation

struct TenantIdListResponse: Decodable, Sendable, BlueMarbleResponse {
  let errorCode: Int
  let success: Bool
  let refreshToken: Bool?
  let message: String
  let payload: [TenantListPayload]?
}

struct TenantListPayload: Decodable, Sendable {
  let id: TenantIDPayload?
  let mdlParameterValue: String?
  let mdlParamDescription: String?
  let mdlUserId: String?
}

struct TenantIDPayload: Decodable, Sendable {
  let mod1ModId: String?
  let mdlParameterId: String?
}

extension TenantIdListResponse {
  func toUiModels() -> [TenantIdDataUIModel] {
    (payload ?? []).map(TenantIdDataUIModel.init(payload:))
  }
}
