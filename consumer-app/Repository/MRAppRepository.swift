//import Foundation
//import Combine
//
//protocol MRAppRepositoryProtocol {
//    func getMemberProfile(request: LoginRequest) async throws -> MemberProfile
//    func getMemberProfilePublisher(request: LoginRequest) -> AnyPublisher<MemberProfile, Error>
//}
//
//final class MRAppRepository: MRAppRepositoryProtocol {
//    private let apiService: APIServiceProtocol
//
//    init(apiService: APIServiceProtocol = DIContainer.shared.resolve(APIServiceProtocol.self)) {
//        self.apiService = apiService
//    }
//
//    func getMemberProfile(request: LoginRequest) async throws -> MemberProfile {
//        try await apiService.getMemberProfileAsync(request: request)
//    }
//
//    func getMemberProfilePublisher(request: LoginRequest) -> AnyPublisher<MemberProfile, Error> {
//        apiService.getMemberProfile(request: request).mapError { $0 as Error }.eraseToAnyPublisher()
//    }
//}
