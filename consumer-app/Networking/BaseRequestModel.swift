import Foundation

class BaseRequestModel {

  var endPoint: String = String.empty
  var method: HTTPMethod = .post
  var requestParams: [String: String]?
  var body: Codable?
  var retryCount: Int = 0
  var secured: Bool = true
  var timeoutInterval: TimeInterval = NetworkConstants.requestTimeout
  var skipTokenRefresh: Bool = false
  var additionalHeaders: [String: String] = [:]

  init() {}

  private var baseHeaders: [String: String] {
    [
      "Content-Type": "application/json;charset=UTF-8",
      "Referer": NetworkConstants.referer
    ]
  }

  var headers: [String: String] {
    baseHeaders
      .merging(additionalHeaders) { _, new in new }
      .filter { !$0.value.isEmpty }
  }

  var url: URL? {
    let baseUrl = NetworkConstants.baseUrl
    let trimmedEndpoint = endPoint.trimmingCharacters(in: .whitespacesAndNewlines)
    let fullPath: String

    if trimmedEndpoint.lowercased().hasPrefix("http") {
      fullPath = trimmedEndpoint
    } else {
      let slash = (baseUrl.hasSuffix("/") || trimmedEndpoint.hasPrefix("/")) ? "" : "/"
      fullPath = baseUrl + slash + trimmedEndpoint
    }

    guard var urlComponents = URLComponents(string: fullPath) else {
      return URL(string: fullPath)
    }

    var queryItems = urlComponents.queryItems ?? []

    if let params = requestParams, !params.isEmpty {
      for (key, value) in params where !value.isEmpty {
        queryItems.append(URLQueryItem(name: key, value: value))
      }
    }

    if NetworkConstants.supportLanguageQuery.contains(endPoint) {
      queryItems.append(URLQueryItem(name: "language", value: SessionManager.shared.getLanguage()))
    }

    if !queryItems.isEmpty {
      urlComponents.queryItems = queryItems
    }

    return urlComponents.url ?? URL(string: fullPath)
  }
}
