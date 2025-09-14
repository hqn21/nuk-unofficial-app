//
//  NavigationManager.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import Foundation
import Combine
import SwiftUI

enum TabSelection: Hashable {
    case home
    case map
    case profile
    case information
}

enum PathDestination: Hashable {
    case donation
    case course
    case timetable
    case score
    case credit
    
    case author
    case reference
    case copyright
}

@MainActor
class NavigationManager: ObservableObject {
    @Published var tabSelection: TabSelection = .home
    @Published var profileNavigationPath: NavigationPath = NavigationPath()
    @Published var informationNavigationPath: NavigationPath = NavigationPath()
    
    func navigate(selection: TabSelection, pathDestination: PathDestination) -> Void {
        switch selection {
        case .profile:
            profileNavigationPath.append(pathDestination)
        case .information:
            informationNavigationPath.append(pathDestination)
        default:
            return
        }
    }
    
    func navigateBack(selection: TabSelection) -> Void {
        switch selection {
        case .profile:
            profileNavigationPath.removeLast()
        case .information:
            informationNavigationPath.removeLast()
        default:
            return
        }
    }
    
    func navigateToRoot(selection: TabSelection) -> Void {
        switch selection {
        case .profile:
            profileNavigationPath.removeLast(profileNavigationPath.count)
        case .information:
            informationNavigationPath.removeLast(informationNavigationPath.count)
        default:
            return
        }
    }
}
