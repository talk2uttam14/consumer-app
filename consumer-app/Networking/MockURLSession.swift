import Foundation

final class MockURLSession: URLSessionProtocol {
    let data: Data
    let response: URLResponse
    let error: Error?

    init(data: Data, response: URLResponse, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let e = error { throw e }
        return (data, response)
    }
}