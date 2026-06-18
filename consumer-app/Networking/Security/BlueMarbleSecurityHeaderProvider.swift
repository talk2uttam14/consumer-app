//
//  BlueMarbleSecurityHeaderProvider.swift
//  consumer-app
//
//  Builds Nonce, Signature, X-Security-Nonce, and X-Watermark headers.
//  Logic matches the legacy iOS_Platform_Library interceptors.
//

import Foundation

struct BlueMarbleSecurityHeaders: Equatable {
  let nonce: String
  let params: String?
  let signature: String
  let securityNonce: String
  let watermark: String

  var asHTTPHeaderFields: [String: String] {
    var headers: [String: String] = [
      "Accept": SecurityConstants.acceptHeader,
      "Content-Type": SecurityConstants.contentType,
      "Nonce": nonce,
      "Signature": signature,
      "User-Agent": SecurityConstants.userAgent,
      "X-Security-Nonce": securityNonce,
      "X-Watermark": watermark,
      "charset": SecurityConstants.charset,
      "language": SecurityConstants.language
    ]

    if let params, !params.isEmpty {
      headers["Params"] = params
    }

    return headers
  }
}

protocol BlueMarbleSecurityHeaderProviding {
  func makeHeaders(for request: URLRequest, bearerToken: String?) -> BlueMarbleSecurityHeaders
}

struct BlueMarbleSecurityHeaderProvider: BlueMarbleSecurityHeaderProviding {

  func makeHeaders(for request: URLRequest, bearerToken: String?) -> BlueMarbleSecurityHeaders {
    let mitmNonce = CryptoHelper.generateRandomNonce()
    let securityNonce = CryptoHelper.generateSecurityNonce()
    let queryString = request.url?.query ?? ""

    let signatureKey = makeSignatureKey(bearerToken: bearerToken, mitmNonce: mitmNonce)
    let signatureBody = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? queryString
    let signature = CryptoHelper.hmacSHA256(message: signatureBody, key: signatureKey)

    let watermarkSecret = "cv.bm.\(securityNonce).\(bearerToken ?? "")"
    let watermarkBody = makeWatermarkBody(method: request.httpMethod ?? "GET", request: request)
    let watermark = CryptoHelper.hmacSHA256(message: watermarkBody, key: watermarkSecret)

    return BlueMarbleSecurityHeaders(
      nonce: mitmNonce,
      params: queryString.isEmpty ? nil : Data(queryString.utf8).base64EncodedString(),
      signature: signature,
      securityNonce: securityNonce,
      watermark: watermark
    )
  }

  private func makeSignatureKey(bearerToken: String?, mitmNonce: String) -> String {
    if let bearerToken, !bearerToken.isEmpty {
      return "\(bearerToken).\(mitmNonce)"
    }
    return "\(SecurityConstants.base64ClientToken).\(mitmNonce)"
  }

  private func makeWatermarkBody(method: String, request: URLRequest) -> String {
    var body = "\(method):\(sortedPathWithQuery(from: request))"
    if let httpBody = request.httpBody,
       let bodyString = String(data: httpBody, encoding: .utf8) {
      body += ":\(bodyString)"
    }
    return body
  }

  private func sortedPathWithQuery(from request: URLRequest) -> String {
    guard let url = request.url,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return request.url?.relativePath ?? ""
    }

    guard let queryItems = components.queryItems, !queryItems.isEmpty else {
      return components.path
    }

    let sortedQuery = queryItems
      .sorted { $0.name < $1.name }
      .compactMap { item -> String? in
        guard let value = item.value else { return nil }
        let name = item.name.removingPercentEncoding ?? item.name
        let decodedValue = value.removingPercentEncoding ?? value
        return "\(name)=\(decodedValue)"
      }
      .joined(separator: "&")

    return "\(components.path)?\(sortedQuery)"
  }
}
