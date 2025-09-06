//
//  KeychainManager.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/22.
//

import Foundation
import OSLog

class KeychainManager {
    static let shared: KeychainManager = KeychainManager()
    private let keychainAccessGroup: String = "88HJ7X4BCT.nukapp"
    private let logger: Logger = Logger(subsystem: "com.haoquan.nukapp", category: "KeychainManager")
    
    func add<T: Codable>(key: String, value: T) -> Bool {
        do {
            let data = try JSONEncoder().encode(value)
            let query: CFDictionary = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key as CFString,
                kSecValueData: data as CFData,
                kSecAttrAccessGroup: keychainAccessGroup as CFString
            ] as CFDictionary
            let status: OSStatus = SecItemAdd(query, nil)
            return status == errSecSuccess
        } catch {
            logger.log(level: .debug, "在 Add Keychain（\(key)）時發生了 Encoding Error（\(error)）")
            return false
        }
    }
    
    func get<T: Codable>(key: String, type: T.Type) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessGroup as String: keychainAccessGroup,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                logger.log(level: .debug, "在 Get Keychain（\(key)）時發生了 Decoding Error（\(error)）")
                return nil
            }
        } else {
            logger.log(level: .debug, "在 Get Keychain（\(key)）時發生了錯誤，狀態碼（\(status.description)）")
            return nil
        }
    }
    
    func update<T: Codable>(key: String, value: T) -> Bool {
        do {
            let data = try JSONEncoder().encode(value)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecAttrAccessGroup as String: keychainAccessGroup
            ]
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: data
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                logger.log(level: .debug, "在 Update Keychain（\(key)）時發生了錯誤，狀態碼（\(status.description)）")
                return false
            }
            return true
        } catch {
            logger.log(level: .debug, "在 Update Keychain（\(key)）時發生了 Encoding Error（\(error)）")
            return false
        }
    }
    
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessGroup as String: keychainAccessGroup
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            logger.log(level: .debug, "在 Delete Keychain（\(key)）時發生了錯誤，狀態碼（\(status.description)）")
            return false
        }
        return true
    }
    
    func addOrUpdate<T: Codable>(key: String, value: T) -> Bool {
        if let _: T = get(key: key, type: T.self) {
            return update(key: key, value: value)
        } else {
            return add(key: key, value: value)
        }
    }
}
