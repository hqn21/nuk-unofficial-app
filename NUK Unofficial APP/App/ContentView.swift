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
    @StateObject private var courseViewModel: CourseViewModel = CourseViewModel()
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
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
                        Text("首頁")
                    }
                    .tag(TabSelection.home)
                MapScreen()
                    .environmentObject(youBikeViewModel)
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .map)
                            .environment(\.symbolVariants, .none)
                        Text("地圖")
                    }
                    .tag(TabSelection.map)
                ProfileScreen()
                    .environmentObject(courseViewModel)
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .profile)
                            .environment(\.symbolVariants, .none)
                        Text("個人")
                    }
                    .tag(TabSelection.profile)
                InformationScreen()
                    .tabItem {
                        viewModel.getTabIcon(currentSelection: navigationManager.tabSelection, targetSelection: .information)
                            .environment(\.symbolVariants, .none)
                        Text("關於")
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
        .alert("NUK Unofficial APP", isPresented: $showWelcomeAlert, actions: {
            Button("確認", action: {
                viewModel.setHasDisplayedWelcomeMessage()
            })
        }, message: {
            Text("這款非官方 APP 由高大資工系和藝創系 115 級學生自主開發，希望能不吝嗇前往 App Store 給予我們評分支持，如有遇到問題也可以前往關於頁面的問題回報與我們聯絡，謝謝。")
        })
        .alert("NUK Unofficial APP", isPresented: $showAlert, actions: {
            Button("確認", action: {})
        }, message: {
            Text(alertMessage)
        })
        .onAppear() {
            WidgetCenter.shared.reloadAllTimelines()
            if !viewModel.hasDisplayedWelcomeMessage() {
                showWelcomeAlert = true
            }
        }
        .onOpenURL { url in
            let param: String = String(url.absoluteString.dropFirst(9))
            if param == "timetable" {
                navigationManager.tabSelection = .profile
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    navigationManager.navigate(selection: .profile, pathDestination: .timetable)
                    self.alertMessage = courseViewModel.importTimetable()
                    self.showAlert = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager())
        .environmentObject(PopupManager())
}
