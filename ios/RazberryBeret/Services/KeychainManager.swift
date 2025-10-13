import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private let service = "com.fladrycreative.razberryberet"
    private let authSessionKey = "auth_session"
    
    private init() {}
    
    // MARK: - Auth Session
    
    func storeAuthSession(_ session: AuthSession) {
        do {
            let data = try JSONEncoder().encode(session)
            storeData(data, forKey: authSessionKey)
        } catch {
            print("Failed to encode auth session: \(error)")
        }
    }
    
    func getAuthSession() -> AuthSession? {
        guard let data = getData(forKey: authSessionKey) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(AuthSession.self, from: data)
        } catch {
            print("Failed to decode auth session: \(error)")
            return nil
        }
    }
    
    func clearAuthSession() {
        deleteData(forKey: authSessionKey)
    }
    
    // MARK: - Generic Keychain Operations
    
    private func storeData(_ data: Data, forKey key: String) {
        // Delete any existing item
        deleteData(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Keychain store failed with status: \(status)")
        }
    }
    
    private func getData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        } else {
            return nil
        }
    }
    
    private func deleteData(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
