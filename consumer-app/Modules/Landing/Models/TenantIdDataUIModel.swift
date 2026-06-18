//
//  TenantIdDataUIModel.swift
//  consumer-app
//

import Foundation

struct TenantIdDataUIModel: Identifiable, Equatable, Sendable {
  let id: String
  let tenantId: String?
  let description: String?
  let userId: String?
  let moduleId: String?
  let parameterId: String?

  init(payload: TenantListPayload) {
    tenantId = payload.mdlParameterValue
    description = payload.mdlParamDescription
    userId = payload.mdlUserId
    moduleId = payload.id?.mod1ModId
    parameterId = payload.id?.mdlParameterId
    id = tenantId ?? UUID().uuidString
  }
}
