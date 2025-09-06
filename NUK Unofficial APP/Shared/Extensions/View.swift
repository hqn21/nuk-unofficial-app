//
//  View.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2022/6/29.
//

import SwiftUI

extension View {
    func alertTF(title: String, message: String, primaryHintText: String, secondaryHintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String, String)->(), secondaryAction: @escaping ()->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = primaryHintText
        }
        alert.addTextField { field in
            field.placeholder = secondaryHintText
            field.isSecureTextEntry = true
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let primaryText = alert.textFields?[0].text, let secondaryText = alert.textFields?[1].text {
                primaryAction(primaryText, secondaryText)
            } else {
                primaryAction("", "")
            }
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func alertT(title: String, message: String, primaryTitle: String, primaryAction: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: primaryTitle, style: .cancel, handler: { _ in
            primaryAction()
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func alertT2(title: String, message: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping ()->(), secondaryAction: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .destructive, handler: { _ in
            primaryAction()
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func alertT3(title: String, message: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping ()->(), secondaryAction: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            primaryAction()
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func rootController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func setTabBarBackgroundVisible() -> some View {
        if #available(iOS 18.0, *) {
            return self.toolbarBackgroundVisibility(.visible, for: .tabBar)
        }
        return self
    }
}
