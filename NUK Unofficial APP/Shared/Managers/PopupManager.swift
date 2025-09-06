//
//  PopupManager.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class PopupManager: ObservableObject {
    @Published var popupView: AnyView? = nil
    
    func isPresented() -> Bool {
        return popupView != nil
    }
    
    func set(popup: AnyView) {
        popupView = popup
    }
    
    func dismiss() {
        popupView = nil
    }
}
