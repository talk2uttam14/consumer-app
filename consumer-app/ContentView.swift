//
//  ContentView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 27/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Call Api") {
                
                APIManager.shared.execute(requestModel: GetLanguageRequestModel()) { (response: GetLanguageResponse) in
                    dump(response)
                } errorCallback: { error in
                    dump(error.localizedDescription)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
class GetLanguageRequestModel: BaseRequestModel {
    override init() {
        super.init()
        self.endPoint = "mobiquitypay/faq/consumer/en"
        self.method = .get
    }
}

struct GetLanguageResponse: Codable {
    let data : [InnerData]?
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([InnerData].self, forKey: .data)
    }
}

struct InnerData: Codable {
    let ans : String?
    let ques : String?

    enum CodingKeys: String, CodingKey {
        case ans = "ans"
        case ques = "ques"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ans = try values.decodeIfPresent(String.self, forKey: .ans)
        ques = try values.decodeIfPresent(String.self, forKey: .ques)
    }
}
