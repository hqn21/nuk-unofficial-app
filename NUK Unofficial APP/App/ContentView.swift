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
                    .environmentObject(courseViewModel)
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
                Button("common.general.confirm", action: {
                    viewModel.setHasDisplayedWelcomeMessage()
                })
            },
            message: {
                Text("common.general.welcome")
            }
        )
        .alert(
            "NUK Unofficial APP",
            isPresented: $showAlert,
            actions: {
                Button("確認", action: {
                    
                })
            },
            message: {
                Text("\(alertMessage)")
            }
        )
        .onAppear() {
            courseViewModel.loadCourse()
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
