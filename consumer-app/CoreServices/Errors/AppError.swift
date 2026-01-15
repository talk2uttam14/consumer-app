//
//  AppError.swift
//  consumer-app
//
//  Comprehensive error handling system for fintech applications
//

import Foundation

// MARK: - Main App Error
public enum AppError: Error {
    case network(NetworkError)
    case business(BusinessError)
    case validation(ValidationError)
    case security(SecurityError)
    case unknown(String)
    
    // MARK: - User-Friendly Messages
    var userMessage: String {
        switch self {
        // Network Errors
        case .network(.noInternetConnection):
            return "Please check your internet connection and try again."
        case .network(.timeout):
            return "The request took too long. Please try again."
        case .network(.unauthorized):
            return "Your session has expired. Please login again."
        case .network(.serverError):
            return "Our servers are experiencing issues. Please try again later."
        case .network(.invalidResponse):
            return "Received an invalid response. Please try again."
            
        // Business Errors
        case .business(.insufficientFunds):
            return "Insufficient balance to complete this transaction."
        case .business(.transactionLimitExceeded):
            return "Transaction limit exceeded. Please contact support."
        case .business(.accountLocked):
            return "Your account has been locked. Please contact support."
        case .business(.serviceUnavailable):
            return "This service is temporarily unavailable. Please try again later."
            
        // Validation Errors
        case .validation(.invalidPin):
            return "Invalid PIN. Please try again."
        case .validation(.invalidAmount):
            return "Please enter a valid amount."
        case .validation(.invalidPhoneNumber):
            return "Please enter a valid phone number."
        case .validation(.invalidInput(let field)):
            return "Invalid \(field). Please check and try again."
            
        // Security Errors
        case .security(.suspiciousActivity):
            return "For your security, this action has been blocked. Please contact support."
        case .security(.tooManyAttempts):
            return "Too many failed attempts. Please try again later."
        case .security(.deviceNotTrusted):
            return "This device is not recognized. Please verify your identity."
        case .security(.biometricFailed):
            return "Biometric authentication failed. Please try again."
            
        case .unknown(let message):
            return message.isEmpty ? "Something went wrong. Please try again later." : message
        }
    }
    
    // MARK: - Error Codes for Tracking
    var errorCode: String {
        switch self {
        // Network
        case .network(.noInternetConnection): return "NET_001"
        case .network(.timeout): return "NET_002"
        case .network(.unauthorized): return "AUTH_401"
        case .network(.serverError(let code)): return "NET_\(code)"
        case .network(.invalidResponse): return "NET_003"
            
        // Business
        case .business(.insufficientFunds): return "BIZ_100"
        case .business(.transactionLimitExceeded): return "BIZ_101"
        case .business(.accountLocked): return "BIZ_102"
        case .business(.serviceUnavailable): return "BIZ_103"
            
        // Validation
        case .validation(.invalidPin): return "VAL_001"
        case .validation(.invalidAmount): return "VAL_002"
        case .validation(.invalidPhoneNumber): return "VAL_003"
        case .validation(.invalidInput): return "VAL_004"
            
        // Security
        case .security(.suspiciousActivity): return "SEC_001"
        case .security(.tooManyAttempts): return "SEC_002"
        case .security(.deviceNotTrusted): return "SEC_003"
        case .security(.biometricFailed): return "SEC_004"
            
        case .unknown: return "UNK_000"
        }
    }
    
    // MARK: - Should Log Flag
    /// Determines if this error should be logged (excludes sensitive errors)
    var shouldLog: Bool {
        switch self {
        case .security(.suspiciousActivity), .security(.deviceNotTrusted):
            return false // Don't log security-sensitive errors
        case .validation(.invalidPin):
            return false // Don't log PIN attempts
        default:
            return true
        }
    }
    
    // MARK: - Severity Level
    var severity: ErrorSeverity {
        switch self {
        case .network(.noInternetConnection), .validation:
            return .low
        case .network(.timeout), .business(.insufficientFunds):
            return .medium
        case .network(.unauthorized), .business(.accountLocked), .security:
            return .high
        case .network(.serverError), .unknown:
            return .critical
        default:
            return .medium
        }
    }
}

// MARK: - Network Errors
public enum NetworkError: Error {
    case noInternetConnection
    case timeout
    case unauthorized
    case serverError(Int)
    case invalidResponse
}

// MARK: - Business Errors
public enum BusinessError: Error {
    case insufficientFunds
    case transactionLimitExceeded
    case accountLocked
    case serviceUnavailable
}

// MARK: - Validation Errors
public enum ValidationError: Error {
    case invalidPin
    case invalidAmount
    case invalidPhoneNumber
    case invalidInput(String)
}

// MARK: - Security Errors
public enum SecurityError: Error {
    case suspiciousActivity
    case tooManyAttempts
    case deviceNotTrusted
    case biometricFailed
}

// MARK: - Error Severity
public enum ErrorSeverity {
    case low
    case medium
    case high
    case critical
}

// MARK: - LocalizedError Conformance
extension AppError: LocalizedError {
    public var errorDescription: String? {
        userMessage
    }
}
