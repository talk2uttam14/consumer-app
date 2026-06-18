//
//  HomeDataUIModel.swift
//  consumer-app
//

import Foundation

struct HomeDataUIModel {
  let data: [HomeLanguageItemDataUIModel]?
}

struct HomeLanguageItemDataUIModel: Identifiable {
  let id = UUID()
  let ans: String
  let ques: String
}
