//
//  SecureStorage.swift
//  consumer-app
//
//  Created for secure credential storage using iOS Keychain
//

import Foundation
import Security

enum KeychainError: Error {
    case unableToSave
    case unableToRetrieve
    case unableToDelete
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .unableToSave:
            return "Failed to save data to Keychain"
        case .unableToRetrieve:
            return "Failed to retrieve data from Keychain"
        case .unableToDelete:
            return "Failed to delete data from Keychain"
        case .invalidData:
            return "Invalid data format"
        }
    }
}

final class SecureStorage {
    static let shared = SecureStorage()
    
    private init() {}
    
    // MARK: - Save
    /// Saves a string value securely to the Keychain
    func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave
        }
    }
    
    // MARK: - Retrieve
    /// Retrieves a string value from the Keychain
    func retrieve(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            }
            throw KeychainError.unableToRetrieve
        }
        
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        
        return value
    }
    
    // MARK: - Delete
    /// Deletes a value from the Keychain
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete
        }
    }
    
    // MARK: - Clear All
    /// Clears all items stored by this app (use with caution)
    func clearAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete
        }
    }
}
