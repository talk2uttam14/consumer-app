
import Foundation
import Security

protocol KeychainServiceProtocol {
    func save(token: String, for account: String) throws
    func load(account: String) -> String?
    func delete(account: String) throws
}

final class KeychainService: KeychainServiceProtocol {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    func save(token: String, for account: String) throws {
        let data = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Item already exists, thus update it.
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if status != errSecSuccess {
                throw KeychainError.unknown(status)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }
    
    func load(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func delete(account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unknown(status)
        }
    }
}
