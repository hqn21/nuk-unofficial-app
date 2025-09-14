//
//  InformationScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI

struct InformationScreen: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var openPolicy: Bool = false
    @State private var openCalendar: Bool = false
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "NULL"
    let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "NULL"
    
    var body: some View {
        NavigationStack(path: $navigationManager.informationNavigationPath) {
            ZStack {
                Color("GRAY")
                VStack(spacing: 0) {
                    List {
                        Section(header: Text("關於開發團隊")) {
                            Button(action: {
                                navigationManager.navigate(selection: .information, pathDestination: .author)
                            }, label: {
                                HStack {
                                    Text("作者資訊")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                        }
                        Section(header: Text("關於 NUK Unofficial APP")) {
                            HStack {
                                Text("版本資訊")
                                    .foregroundStyle(Color("DARK_GRAY"))
                                Spacer()
                                Text("\(version) (\(buildVersion))")
                                    .foregroundStyle(Color("FOOTER"))
                            }
                            Button(action: {
                                navigationManager.navigate(selection: .information, pathDestination: .reference)
                            }, label: {
                                HStack {
                                    Text("資料來源")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            Button(action: {
                                navigationManager.navigate(selection: .information, pathDestination: .copyright)
                            }, label: {
                                HStack {
                                    Text("版權聲明")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            Button(action: {
                                openPolicy = true
                            }, label: {
                                HStack {
                                    Text("隱私政策")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            Button(action: {
                                
                            }, label: {
                                HStack {
                                    Text("問題回報")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            ShareLink(item: URL(string: "https://nukapp.haoquan.me")!) {
                                HStack {
                                    Text("推薦給他人")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        Section(header: Text("關於國立高雄大學")) {
                            Button(action: {
                                navigationManager.navigate(selection: .information, pathDestination: .contact)
                            }, label: {
                                HStack {
                                    Text("聯繫資訊")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            Button(action: {
                                openCalendar = true
                            }, label: {
                                HStack {
                                    Text("行事曆")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                        }
                    }
                    .fullScreenCover(isPresented: $openPolicy, content: {
                        SafariView(url: URL(string: "https://nukapp.haoquan.me/policy")!)
                            .edgesIgnoringSafeArea(.all)
                    })
                    .fullScreenCover(isPresented: $openCalendar, content: {
                        SafariView(url: URL(string: "https://sec.nuk.edu.tw/p/412-1002-525.php?Lang=zh-tw")!)
                            .edgesIgnoringSafeArea(.all)
                    })
                    .scrollContentBackground(.hidden)
                    .background(Color("GRAY"))
                    .padding(.top, 0.2)
                }
            }
            .navigationTitle("關於")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDestination.self) { destination in
                switch destination {
                case PathDestination.donation:
                    EmptyView()
                case PathDestination.course:
                    EmptyView()
                case PathDestination.timetable:
                    EmptyView()
                case PathDestination.score:
                    EmptyView()
                case PathDestination.credit:
                    EmptyView()
                case PathDestination.author:
                    AuthorScreen()
                case PathDestination.reference:
                    ReferenceScreen()
                case PathDestination.copyright:
                    CopyrightScreen()
                case PathDestination.privacy:
                    PrivacyScreen()
                case PathDestination.contact:
                    ContactScreen()
                }
            }
        }
    }
}

#Preview {
    InformationScreen()
        .environmentObject(NavigationManager())
}
