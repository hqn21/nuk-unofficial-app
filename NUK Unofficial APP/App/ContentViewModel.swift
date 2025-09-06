//
//  ContentViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/22.
//

import Foundation
import Combine
import SwiftUI

class ContentViewModel: ObservableObject {
    func getTabIcon(currentSelection: TabSelection, targetSelection: TabSelection) -> some View {
        let imageSystemNames: [TabSelection: String] = [
            .home: "house",
            .map: "map",
            .profile: "person",
            .information: "number.square"
        ]
        let image: Image = Image(systemName: "\(imageSystemNames[targetSelection] ?? "house")")
        if currentSelection == targetSelection {
            return image.symbolVariant(.fill)
        }
        return image.symbolVariant(.none)
    }
    
    func hasDisplayedWelcomeMessage() -> Bool {
        if let hasDesplayed = UserDefaults().value(forKey: "welcome_message") as? Bool {
            return hasDesplayed
        }
        return false
    }
    
    func setHasDisplayedWelcomeMessage() {
        UserDefaults().set(true, forKey: "welcome_message")
    }
}

