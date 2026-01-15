//
//  GetLanguageResponse.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


public struct GetLanguageResponse: Codable, Sendable {
    public let data : [InnerData]?
    public enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([InnerData].self, forKey: .data)
    }
}

public struct InnerData: Codable, Sendable {
    public let ans : String?
    public let ques : String?

    public enum CodingKeys: String, CodingKey {
        case ans = "ans"
        case ques = "ques"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ans = try values.decodeIfPresent(String.self, forKey: .ans)
        ques = try values.decodeIfPresent(String.self, forKey: .ques)
    }
}
