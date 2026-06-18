//
//  LanguageResponseModel.swift
//  consumer-app
//
//  Shared FAQ language API models (used by Home + Login features).
//

import Foundation

struct GetLanguageResponse: Codable, Sendable {
  let data: [LanguageItem]?
}

struct LanguageItem: Codable, Sendable {
  let ans: String?
  let ques: String?
}

extension GetLanguageResponse {

  func toHomeDataUIModel() -> HomeDataUIModel {
    let items = (data ?? []).map { item in
      HomeLanguageItemDataUIModel(
        ans: item.ans ?? "",
        ques: item.ques ?? ""
      )
    }
    return HomeDataUIModel(data: items)
  }
}
