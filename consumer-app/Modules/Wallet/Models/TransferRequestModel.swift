//
//  TransferRequestModel.swift
//  consumer-app
//

import Foundation

struct TransferRequest: Codable, Sendable {
  let amount: String
  let recipientMobile: String
}
