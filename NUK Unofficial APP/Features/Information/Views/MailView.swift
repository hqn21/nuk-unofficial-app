//
//  MailView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2022/6/24.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "NULL"
        let appBuildNum = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "NULL"
        
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["contact@haoquan.me"])
        vc.setSubject("NUK Unofficial APP 問題回報")
        vc.setMessageBody("\n\n\n\n\n\n----------\n請詳細描述問題或建議，謝謝。（下方系統資訊請勿更改以便開發人員判斷）\nDevice Name: \(UIDevice.current.modelName)\nDevice Version: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)\nAPP Build Number: \(appBuildNum)\nAPP Version: \(appVersion)", isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
    }
}
