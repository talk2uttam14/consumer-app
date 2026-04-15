
//
//  LoginMobileWithPinView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 12/02/26.
//

import SwiftUI

struct LanguageInnerUIModel: Identifiable {
    let id = UUID()
    let question: String
    let answers: String
}
struct LanguageDataUIModel {
    let languageList: [LanguageInnerUIModel]
}

struct UserData: Codable {
    let name: String
    let bio: String
}
