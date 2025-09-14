//
//  InformationScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI
import MessageUI

struct InformationScreen: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel: InformationViewModel = InformationViewModel()
    @State private var openPolicy: Bool = false
    @State private var openCalendar: Bool = false
    @State private var openMail: Bool = false
    @State private var openAdmin: Bool = false
    @State private var openAcademic: Bool = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
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
                                if MFMailComposeViewController.canSendMail() {
                                    openMail = true
                                } else {
                                    viewModel.alertMessage = "您需要安裝 Apple 官方的 Mail App 才能進行問題回報，如已下載請在 Mail App 登入您的電子郵件來忽視此警告"
                                }
                            }, label: {
                                HStack {
                                    Text("問題回報")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            .sheet(isPresented: $openMail) {
                                MailView(result: $mailResult)
                                    .edgesIgnoringSafeArea(.bottom)
                            }
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
                                openAdmin = true
                            }, label: {
                                HStack {
                                    Text("行政單位")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            })
                            Button(action: {
                                openAcademic = true
                            }, label: {
                                HStack {
                                    Text("教學單位")
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
                    .fullScreenCover(isPresented: $openAdmin, content: {
                        SafariView(url: URL(string: "https://www.nuk.edu.tw/p/412-1000-220.php?Lang=zh-tw")!)
                            .edgesIgnoringSafeArea(.all)
                    })
                    .fullScreenCover(isPresented: $openAcademic, content: {
                        SafariView(url: URL(string: "https://www.nuk.edu.tw/p/412-1000-221.php?Lang=zh-tw")!)
                            .edgesIgnoringSafeArea(.all)
                    })
                    .scrollContentBackground(.hidden)
                    .background(Color("GRAY"))
                    .padding(.top, 0.2)
                }
            }
            .alert(
                "關於",
                isPresented: $viewModel.showAlert,
                actions: {
                    Button("確認", action: {})
                },
                message: {
                    Text("\(viewModel.alertMessage ?? "未知錯誤")")
                }
            )
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
                }
            }
        }
    }
}

#Preview {
    InformationScreen()
        .environmentObject(NavigationManager())
}
