//import Foundation
//import Combine
//
//struct APIError: Error, Codable {
//    let code: String
//    let message: String
//    let details: String?
//    let timestamp: String
//}
//
//protocol APIServiceProtocol {
//    // async-first
//    func getMemberProfileAsync(request: LoginRequest) async throws -> MemberProfile
//    // Combine wrapper
//    func getMemberProfile(request: LoginRequest) -> AnyPublisher<MemberProfile, APIError>
//    // implement other endpoints similarly...
//}
//
//final class APIService: APIServiceProtocol {
//    private let apiManager: APIManagerProtocol
//    private let appConfig: AppConfig
//    private let decoder = JSONDecoder()
//
//    init(apiManager: APIManagerProtocol = APIManager.shared, appConfig: AppConfig) {
//        self.apiManager = apiManager
//        self.appConfig = appConfig
//        let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        decoder.dateDecodingStrategy = .formatted(df)
//    }
//
//    func getMemberProfileAsync(request: LoginRequest) async throws -> MemberProfile {
//        var model = BaseRequestModel(path: "/get-member-profile", method: .POST)
//        model.body = request
//        model.timeoutInterval = 30
//        // configure url from environment if needed
//        if model.url == nil {
//            model.url = URL(string: appConfig.currentEnvironment.baseURL + (model.path ?? ""))
//        }
//        return try await apiManager.executeAsync(requestModel: model)
//    }
//
//    func getMemberProfile(request: LoginRequest) -> AnyPublisher<MemberProfile, APIError> {
//        Future { promise in
//            Task {
//                do {
//                    let res = try await self.getMemberProfileAsync(request: request)
//                    promise(.success(res))
//                } catch let apiErr as APIError {
//                    promise(.failure(apiErr))
//                } catch {
//                    let mapped = APIError(code: "UNKNOWN", message: error.localizedDescription, details: nil, timestamp: ISO8601DateFormatter().string(from: Date()))
//                    promise(.failure(mapped))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}
