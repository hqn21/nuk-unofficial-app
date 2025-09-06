//
//  ActionViewController.swift
//  ImportTimetable
//
//  Created by Haoquan Liu on 2024/11/25.
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
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
    
    func update(key: String, value: Any) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "\(key)",
            kSecAttrAccessGroup: keyChainAccessGroupName as AnyObject
        ] as CFDictionary
        
        var updateFields: CFDictionary? = nil
        
        if let detail = value as? String {
            updateFields = [
                kSecValueData: detail.data(using: String.Encoding.utf8)!,
                kSecAttrAccessGroup: keyChainAccessGroupName as AnyObject
            ] as CFDictionary
        }
        
        if updateFields == nil { // 如果輸入值不合法
            return false
        } else { // 如果輸入值合法
            let status = SecItemUpdate(query, updateFields!) // 將 KeyChain 中指定的值更新並獲取狀態碼
            if status != 0 { // 如果更新失敗
                return false
            }
                
            return true
        }
    }
    
    func searchString(key: String) -> String? {
        var result: String? = nil
        if let data = search(key: "\(key)") {
            result = String(data: data, encoding: String.Encoding.utf8)
        }
        return result
    }
        
    // https://stackoverflow.com/questions/70431456/ios-action-extension-cannot-open-containing-app
    func openApp(param: String) {
        let scheme = "nukapp://\(param)"
        guard let appURL = URL(string: scheme) else {
            print("Invalid URL: \(scheme)")
            return
        }
        
        // Traverse the responder chain to find an instance of UIApplication
        var responder = self as UIResponder?
        responder = (responder as? UIViewController)?.parent
        
        while responder != nil && !(responder is UIApplication) {
            responder = responder?.next
        }
        
        if let application = responder as? UIApplication {
            // Use the modern open(_:options:completionHandler:) method
            application.open(appURL, options: [:], completionHandler: { success in
                if success {
                    print("Successfully opened app with URL: \(appURL)")
                } else {
                    print("Failed to open app with URL: \(appURL)")
                }
            })
        } else {
            print("UIApplication not found in responder chain.")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // saveHTML
        let item = extensionContext!.inputItems.first as! NSExtensionItem
        let propertyList = UTType.propertyList.identifier as String
        for attachment in item.attachments ?? [] where attachment.hasItemConformingToTypeIdentifier(propertyList) {
            attachment.loadItem(forTypeIdentifier: propertyList) { (item, error) in
                guard let dictionary = item as? NSDictionary,
                      let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                      let urlString = results["url"] as? String,
                      let url = URL(string: urlString),
                      let urlDomain = url.host,
                      let html = results["html"] as? String else {
                    return
                }
                
                if(self.search(key: "url_temp") == nil) {
                    if(!self.save(key: "url_temp", value: urlDomain)) {
                        print("save url_temp error")
                    }
                } else {
                    if(!self.update(key: "url_temp", value: urlDomain)) {
                        print("update url_temp error")
                    }
                }
                
                if(self.search(key: "timetable_html") == nil) {
                    if(!self.save(key: "timetable_html", value: html)) {
                        print("save timetable_html error")
                    }
                } else {
                    if(!self.update(key: "timetable_html", value: html)) {
                        print("update timetable_html error")
                    }
                }
            }
        }
        
        self.openApp(param: "timetable")
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
