//
//  ContentView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 27/10/25.
//
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var router: AppRouter
    @State private var isLoading = false
    @State private var isSuccess = false
    var body: some View {
        VStack(spacing: 16) {
            Text("Hello, world!")
            PrimaryButton(title: "Call Api", action: {
                callApi()
                isLoading = true
            }, isLoading: isLoading, isSuccess: isSuccess)
        }
        .padding()
        .onAppear(perform: {
            isLoading = false
            isSuccess = false
        })
    }
        
     func callApi() {
        APIManager.shared.execute(
            requestModel: GetLanguageRequestModel()
        ) { (_: GetLanguageResponse) in
            // Navigate AFTER API success
            isLoading = false
            isSuccess = true
            router.push(.home(.home))
        } errorCallback: { error in
            isLoading = false
            isSuccess = false
            print(error.localizedDescription)
        }
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
