//
//  APIClient.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 29/10/25.
//
import Foundation

class APIManager {
    static let sharedInstance = APIManager()
    private init() {}
    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpShouldSetCookies = true
        config.waitsForConnectivity = true
        config.allowsConstrainedNetworkAccess = true
        return URLSession(configuration: config)
    }()
    
    func execute<T: Codable>(
        requestModel: BaseRequestModel,
        successCallback: @escaping (_ data: T) -> Void,
        errorCallback: @escaping (_ error: Error) -> Void
    ) {
        
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async {
                errorCallback(NetworkErrorLogger.noInternetConnection)
            }
            return
        }
        guard let url = requestModel.url else {
            DispatchQueue.main.async {
                errorCallback(NetworkErrorLogger.invalidURL)
            }
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestModel.method.rawValue
        urlRequest.timeoutInterval = requestModel.timeoutInterval
        urlRequest.allHTTPHeaderFields = requestModel.headers
        
        LogUtils.print("\(requestModel.method.rawValue) | URL: \(urlRequest.url?.absoluteString ?? "No URL")")
        NetworkLogger.printPrettyHeaders(from: urlRequest)
        
        if let body = requestModel.body {
            do {
                let encodedBody = try JSONEncoder().encode(AnyEncodable(body))
                urlRequest.httpBody = encodedBody
                NetworkLogger.printPrettyJson(String(data: encodedBody, encoding: .utf8))
            } catch {
                DispatchQueue.main.async {
                    errorCallback(NetworkErrorLogger.decodingError(error))
                }
                return
            }
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                if requestModel.retryCount < NetworkConstants.maxRetryCount {
                    LogUtils.print("Retrying... Attempt \(requestModel.retryCount + 1)")
                    let updatedModel = requestModel
                    updatedModel.retryCount += 1
                    self.execute(requestModel: updatedModel, successCallback: successCallback, errorCallback: errorCallback)
                } else {
                    DispatchQueue.main.async {
                        errorCallback(NetworkErrorLogger.requestFailed)
                    }
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorCallback(NetworkErrorLogger.invalidResponse)
                }
                return
            }
            
            do {
                try self.validate(httpResponse)
            } catch {
                DispatchQueue.main.async {
                    errorCallback(error)
                }
                return
            }
            
            // Handle empty response
            guard let data = data else {
                DispatchQueue.main.async {
                    errorCallback(NetworkErrorLogger.noDataError)
                }
                return
            }
            
            LogUtils.print("Response Data:")
            NetworkLogger.printPrettyJson(String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            do {
                /// Try decoding into APIResponse<T> (wrapped)
                if let wrapped = try? decoder.decode(APIResponse<T>.self, from: data) {
                    DispatchQueue.main.async {
                        successCallback(wrapped.payload)
                    }
                    return
                }
                
                /// Try decoding directly into T (unwrapped)
                if let direct = try? decoder.decode(T.self, from: data) {
                    DispatchQueue.main.async {
                        successCallback(direct)
                    }
                    return
                }
                
                if let error = try? decoder.decode(ErrorResponseModel.self, from: data) {
                    DispatchQueue.main.async {
                        errorCallback(NSError(
                            domain: "",
                            code: error.errorCode ?? -1,
                            userInfo: [
                                "errorCode": error.errorCode ?? -1,
                                "success": error.success ?? false,
                                "refreshToken": error.refreshToken ?? false,
                                "message": error.message ?? String.empty,
                            ]
                        ))
                    }
                    return
                }
                
                if let error = try? decoder.decode(APIResponse<ErrorResponseModel>.self, from: data) {
                    DispatchQueue.main.async {
                        errorCallback(NSError(
                            domain: "",
                            code: error.errorCode,
                            userInfo: [
                                "reason": error.payload.reason ?? String.empty,
                                "errorCode": error.errorCode,
                                "success": error.success,
                                "refreshToken": error.refreshToken,
                                "message": error.message
                            ]
                        ))
                    }
                    
                    return
                }
                throw NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unable to decode response"])
            } catch {
                LogUtils.e("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorCallback(error as NSError)
                }
            }
        }
        task.resume()
    }
    func validate(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkErrorLogger.unauthorized
        case 400...499:
            throw NetworkErrorLogger.clientError(code: response.statusCode)
        case 500...599:
            throw NetworkErrorLogger.serverError(code: response.statusCode)
        default:
            throw NetworkErrorLogger.invalidResponse
        }
    }
}
