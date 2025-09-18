//
//  ProfileScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: CourseViewModel
    
    var body: some View {
        NavigationStack(path: $navigationManager.profileNavigationPath) {
            ZStack(alignment: .top) {
                Color("GRAY")
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        DonationButtonView(goView: true)
                        Text("校務系統")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 15) {
                            NavigationCardView(destination: .course, destinationName: "課程查詢", destinationImageName: "CourseSearch", enable: true)
                            NavigationCardView(destination: .timetable, destinationName: "個人課表", destinationImageName: "Timetable", enable: true)
                        }
                        HStack(spacing: 15) {
                            NavigationCardView(destination: .score, destinationName: "成績查詢", destinationImageName: "Score", enable: false)
                            NavigationCardView(destination: .credit, destinationName: "學分分析", destinationImageName: "CreditAnalysis", enable: false)
                        }
                        Text("快速連結")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 15) {
                            LinkCardView(link: "https://course.nuk.edu.tw/Sel/login.asp", linkName: "選課系統", linkImageName: "CourseSystem")
                            LinkCardView(link: "https://aca.nuk.edu.tw/Student2/login.asp", linkName: "教務系統", linkImageName: "AcademicSystem")
                        }
                        HStack(spacing: 15) {
                            LinkCardView(link: "https://sa.nuk.edu.tw/p/403-1009-419-1.php?Lang=zh-tw", linkName: "宿舍官網", linkImageName: "Dorm")
                            LinkCardView(link: "https://stu.nuk.edu.tw/eabsnew/login.asp", linkName: "請假管理", linkImageName: "Leave")
                        }
                    }
                    .padding(15)
                }
            }
            .alert(
                "個人",
                isPresented: .constant(viewModel.alertMessage != nil),
                actions: {
                    Button("確認", action: {
                        viewModel.alertMessage = nil
                    })
                },
                message: {
                    Text("\(viewModel.alertMessage ?? "未知錯誤")")
                }
            )
            .task {
                await viewModel.getCourseIfNeeded()
                await viewModel.getProgramIfNeeded()
                await viewModel.getDepartmentIfNeeded()
            }
            .navigationTitle("個人")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDestination.self) { destination in
                switch destination {
                case PathDestination.donation:
                    DonationScreen()
                case PathDestination.course:
                    CourseScreen()
                case PathDestination.timetable:
                    TimetableScreen()
                case PathDestination.score:
                    ScoreScreen()
                case PathDestination.credit:
                    CreditScreen()
                    
                case PathDestination.author:
                    EmptyView()
                case PathDestination.reference:
                    EmptyView()
                case PathDestination.copyright:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(NavigationManager())
}
