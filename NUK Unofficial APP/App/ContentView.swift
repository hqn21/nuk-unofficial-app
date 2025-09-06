//
//  ContentView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2022/5/26.
//

import SwiftUI
import Combine
import WidgetKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var popupManager: PopupManager
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var youBikeViewModel: YouBikeViewModel = YouBikeViewModel()
    @State private var showWelcomeAlert: Bool = false
    
    var tabSelectionBinding: Binding<TabSelection> {
        Binding(
            get: {
                self.navigationManager.tabSelection
            },
            set: {
                if $0 == self.navigationManager.tabSelection && $0 != .home && $0 != .map {
                    self.navigationManager.navigateToRoot(selection: $0)
                } else {
                    self.navigationManager.tabSelection = $0
                }
            }
        )
    }
    
    init() {
        if #unavailable(iOS 18.0) {
            UITabBar.appearance().backgroundColor = UIColor(Color("WHITE"))
        }
    }
    
    var body: some View {
        TabView(selection: tabSelectionBinding) {
            Group {
                HomeScreen()
                    .environmentObject(youBikeViewModel)
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .home)
                            .environment(\.symbolVariants, .none)
                        Text("home.title")
                    }
                    .tag(TabSelection.home)
                MapScreen()
                    .environmentObject(youBikeViewModel)
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .map)
                            .environment(\.symbolVariants, .none)
                        Text("map.title")
                    }
                    .tag(TabSelection.map)
                ProfileScreen()
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .profile)
                            .environment(\.symbolVariants, .none)
                        Text("profile.title")
                    }
                    .tag(TabSelection.profile)
                InformationScreen()
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .information)
                            .environment(\.symbolVariants, .none)
                        Text("information.title")
                    }
                    .tag(TabSelection.information)
            }
            .setTabBarBackgroundVisible()
        }
        .edgesIgnoringSafeArea(.all)
        .accentColor(Color("DARK_GRAY"))
        .overlay(
            Color.black
                .ignoresSafeArea()
                .opacity(popupManager.isPresented() ? (colorScheme == .dark ? 0.5 : 0.2) : 0)
                .onTapGesture {
                    popupManager.dismiss()
                }
        )
        .overlay(
            Group {
                if let popupView = popupManager.popupView {
                    popupView
                }
            }
        )
        .animation(.spring(), value: popupManager.isPresented())
        .alert(
            "NUK Unofficial APP",
            isPresented: $showWelcomeAlert,
            actions: {
                Button("common.confirm", action: {
                    viewModel.setHasDisplayedWelcomeMessage()
                })
            },
            message: {
                Text("common.welcome")
            }
        )
        .onAppear() {
            WidgetCenter.shared.reloadAllTimelines()
            
            if !viewModel.hasDisplayedWelcomeMessage() {
                showWelcomeAlert = true
            }
        }
        .onOpenURL { url in
            navigationManager.tabSelection = .information
            navigationManager.navigate(selection: .information, pathDestination: .author)
            navigationManager.navigate(selection: .information, pathDestination: .donation)
            navigationManager.navigate(selection: .information, pathDestination: .reference)
            navigationManager.navigate(selection: .information, pathDestination: .copyright)
            navigationManager.navigate(selection: .information, pathDestination: .contact)
//            let param: String = String(url.absoluteString.dropFirst(9))
//            self.alertT(title: "NUK Unofficial APP", message: "\(param)", primaryTitle: "確認", primaryAction: {})
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager())
        .environmentObject(PopupManager())
}
