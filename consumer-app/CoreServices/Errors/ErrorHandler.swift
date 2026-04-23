//
//  ErrorHandler.swift
//  consumer-app
//
//  Centralized error handling and mapping for API errors
//

import Foundation

/// ErrorHandler maps various error types to AppError with proper error codes
final class ErrorHandler {
    
    // MARK: - Map Error to AppError
    /// Converts any Error to AppError with proper categorization
    static func mapToAppError(_ error: Error) -> AppError {
        // Check if already AppError
        if let appError = error as? AppError {
            return appError
        }
        
        // Check if NetworkErrorLogger
        if let networkError = error as? NetworkErrorLogger {
            return networkError.asAppError
        }
        
        // Check if NSError with custom domain
        if let nsError = error as NSError? {
            return handleNSError(nsError)
        }
        
        // Fallback to unknown error
        return .unknown(error.localizedDescription)
    }
    
    // MARK: - Handle NSError
    /// Maps NSError to appropriate AppError based on domain and code
    private static func handleNSError(_ error: NSError) -> AppError {
        switch error.domain {
        case "APIError":
            return handleAPIError(error)
            
        case NetworkErrorLogger.domain:
            return handleNetworkError(error)
            
        case NSURLErrorDomain:
            return handleURLError(error)
            
        default:
            let message = error.userInfo["message"] as? String ?? error.localizedDescription
            return .unknown(message)
        }
    }
    
    // MARK: - Handle API Error
    /// Maps API error codes to specific business/validation errors
    private static func handleAPIError(_ error: NSError) -> AppError {
        let errorCode = error.code
        let reason = error.userInfo["reason"] as? String ?? ""
        let message = error.userInfo["message"] as? String ?? ""
        
        // Map based on error code ranges
        switch errorCode {
        // Authentication & Authorization (1000-1099)
        case 1001:
            return .security(.tooManyAttempts)
        case 1002:
            return .validation(.invalidPin)
        case 1003:
            return .network(.unauthorized)
            
        // Account & Business Logic (2000-2099)
        case 2001:
            return .business(.accountLocked)
        case 2002:
            return .business(.insufficientFunds)
        case 2003:
            return .business(.transactionLimitExceeded)
        case 2004:
            return .business(.serviceUnavailable)
            
        // Validation Errors (3000-3099)
        case 3001:
            return .validation(.invalidPhoneNumber)
        case 3002:
            return .validation(.invalidAmount)
        case 3003:
            return .validation(.invalidInput(reason))
            
        // Security Errors (4000-4099)
        case 4001:
            return .security(.suspiciousActivity)
        case 4002:
            return .security(.deviceNotTrusted)
        case 4003:
            return .security(.biometricFailed)
            
        // Server Errors (5000+)
        case 5000...5999:
            return .network(.serverError(errorCode))
            
        default:
            // Use message from error if available
            let errorMessage = !message.isEmpty ? message : (!reason.isEmpty ? reason : "An error occurred")
            return .unknown(errorMessage)
        }
    }
    
    // MARK: - Handle Network Error
    private static func handleNetworkError(_ error: NSError) -> AppError {
        switch error.code {
        case -1009: // No internet
            return .network(.noInternetConnection)
        case -1001: // Timeout
            return .network(.timeout)
        case 401:
            return .network(.unauthorized)
        case 500...599:
            return .network(.serverError(error.code))
        default:
            return .network(.invalidResponse)
        }
    }
    
    // MARK: - Handle URL Error
    private static func handleURLError(_ error: NSError) -> AppError {
        switch error.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            return .network(.noInternetConnection)
        case NSURLErrorTimedOut:
            return .network(.timeout)
        case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
            return .network(.serverError(error.code))
        default:
            return .network(.invalidResponse)
        }
    }
    
    // MARK: - Log Error
    /// Logs error if it should be logged based on severity
    static func logError(_ appError: AppError) {
        guard appError.shouldLog else { return }
        
        let logMessage = """
        ❌ Error Occurred:
        Code: \(appError.errorCode)
        Severity: \(appError.severity)
        Message: \(appError.userMessage)
        """
        
        LogUtils.print(logMessage)
        
        // In production, send to analytics/crash reporting
        // Analytics.logError(appError.errorCode, message: appError.userMessage)
    }
}
