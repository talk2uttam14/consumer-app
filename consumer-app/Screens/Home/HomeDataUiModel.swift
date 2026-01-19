//
//  GetLanguageResponse.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//

import Foundation

//DataUI Model
struct HomeDataUiModel {
    public let data: [HomeInnerDataUiModel]?
}
struct HomeInnerDataUiModel: Identifiable {
    let id = UUID()
    public let ans: String?
    public let ques: String?
}


//Response Model
public struct GetLanguageResponse: Codable, Sendable {
    public let data: [InnerData]?
}

public struct InnerData: Codable, Sendable {
    public let ans: String?
    public let ques: String?
}
