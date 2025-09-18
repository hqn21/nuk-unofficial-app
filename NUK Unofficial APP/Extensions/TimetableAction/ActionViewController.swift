//
//  ActionViewController.swift
//  TimetableAction
//
//  Created by Hao-Quan Liu on 2024/11/25.
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
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
//                      let url = URL(string: urlString),
//                      let urlDomain: String = url.host,
                      let html: String = results["html"] as? String else {
                    return
                }
                _ = KeychainManager.shared.addOrUpdate(key: "action_timetable_url", value: urlString)
                _ = KeychainManager.shared.addOrUpdate(key: "action_timetable_html", value: html)
            }
        }
        self.openApp(param: "timetable")
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
