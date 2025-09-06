//
//  KeyChainService.swift
//  TimetableExtension
//
//  Created by Haoquan Liu on 2022/10/26.
//

import Foundation
import SwiftUI
import WidgetKit

class KeyChainService: ObservableObject {
    let keyChainAccessGroupName: String = "88HJ7X4BCT.keyChainGroup1"
    
    private func search(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "\(key)",
            kSecReturnData: true,
            kSecAttrAccessGroup: keyChainAccessGroupName as AnyObject
        ] as CFDictionary
        
        var result: AnyObject? = nil
        let status = SecItemCopyMatching(query, &result)
        
        if status != 0 {
            return nil
        }
        
        return result as? Data
    }
    
    func save(key: String, value: Any) -> Bool {
        var query: CFDictionary? = nil
        
        // 檢查輸入值的型態並確認是否合法
        if let detail = value as? String {
            query = [
                kSecValueData: detail.data(using: String.Encoding.utf8)!,
                kSecAttrAccount: "\(key)",
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccessGroup: keyChainAccessGroupName as AnyObject
            ] as CFDictionary
        }
        
        if query == nil { // 如果輸入值不合法
            return false
        } else { // 如果輸入值合法
            let status = SecItemAdd(query!, nil) // 將輸入值存入 KeyChain 並獲取狀態碼
            
            if status != 0 { // 如果存入 KeyChain 失敗
                return false
            
            } else { // 如果存入 KeyChain 成功
                return true
            }
        }
    }
    
    func searchString(key: String) -> String? {
        var cookie: String? = nil
        if let data = search(key: "\(key)") {
            cookie = String(data: data, encoding: String.Encoding.utf8)
        }
        return cookie
    }
}
