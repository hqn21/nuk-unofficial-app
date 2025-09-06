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
    
    // MARK: - 搜尋 Timetable
    func searchTimetable(key: String) -> [[CourseInformation]]? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "\(key)",
            kSecReturnData: true,
            kSecAttrAccessGroup: keyChainAccessGroupName as AnyObject
        ] as CFDictionary
        
        var retrivedResult: AnyObject? = nil
        let status = SecItemCopyMatching(query, &retrivedResult)
        
        if status != 0 {
            return nil
        } else if let result = retrivedResult as? Data {
            return try? PropertyListDecoder().decode([[CourseInformation]].self, from: result)
        } else {
            return nil
        }
    }
}
