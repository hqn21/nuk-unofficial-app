//
//  NUK Unofficial APP.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2022/5/26.
//

import SwiftUI

@main
struct NUK_Unofficial_APP: App {
    @StateObject var navigationManager = NavigationManager()
    @StateObject var popupManager = PopupManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .environmentObject(popupManager)
        }
    }
}
