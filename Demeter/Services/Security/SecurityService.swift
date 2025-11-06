import Foundation
import Security

/// SecurityService handles secure storage and retrieval of sensitive credentials
/// using iOS Keychain with appropriate access controls.
class SecurityService {
    static let shared = SecurityService()
    
    private let serviceName = "com.demeter.app"
    
    enum SecurityError: LocalizedError {
        case keychainStorageFailed(OSStatus)
        case keychainRetrievalFailed(OSStatus)
        case keychainDeletionFailed(OSStatus)
        case invalidKeyFormat
        case noKeyFound
        
        var errorDescription: String? {
            switch self {
            case .keychainStorageFailed(let status):
                return "Failed to store key in Keychain (status: \(status))"
            case .keychainRetrievalFailed(let status):
                return "Failed to retrieve key from Keychain (status: \(status))"
            case .keychainDeletionFailed(let status):
                return "Failed to delete key from Keychain (status: \(status))"
            case .invalidKeyFormat:
                return "Invalid key format"
            case .noKeyFound:
                return "No key found in Keychain"
            }
        }
    }
    
    /// Store an API key securely in Keychain
    /// - Parameters:
    ///   - key: The API key to store
    ///   - account: The account identifier (e.g., "openai_api_key")
    /// - Throws: SecurityError if storage fails
    func storeAPIKey(_ key: String, account: String) throws {
        // Validate key format
        guard !key.isEmpty else {
            throw SecurityError.invalidKeyFormat
        }
        
        // Convert key to data
        guard let keyData = key.data(using: .utf8) else {
            throw SecurityError.invalidKeyFormat
        }
        
        // Delete existing key if present
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        // Create new keychain item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecAttrSynchronizable as String: false
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecurityError.keychainStorageFailed(status)
        }
    }
    
    /// Retrieve an API key from Keychain
    /// - Parameter account: The account identifier (e.g., "openai_api_key")
    /// - Returns: The stored API key
    /// - Throws: SecurityError if retrieval fails
    func retrieveAPIKey(account: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw SecurityError.noKeyFound
            }
            throw SecurityError.keychainRetrievalFailed(status)
        }
        
        guard let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            throw SecurityError.invalidKeyFormat
        }
        
        return key
    }
    
    /// Delete an API key from Keychain
    /// - Parameter account: The account identifier (e.g., "openai_api_key")
    /// - Throws: SecurityError if deletion fails
    func deleteAPIKey(account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecurityError.keychainDeletionFailed(status)
        }
    }
    
    /// Check if an API key exists in Keychain
    /// - Parameter account: The account identifier
    /// - Returns: true if key exists, false otherwise
    func keyExists(account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}