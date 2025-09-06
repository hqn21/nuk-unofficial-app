//
//  ProfileScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.profileNavigationPath) {
            ZStack(alignment: .top) {
                Color("GRAY")
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        DonationButtonView(goView: true)
                        Text("profile.academic")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 15) {
                            NavigationCardView(destination: .course, destinationName: String(localized: "profile.academic.course"))
                            NavigationCardView(destination: .timetable, destinationName: String(localized: "profile.academic.timetable"))
                        }
                        HStack(spacing: 15) {
                            NavigationCardView(destination: .score, destinationName: String(localized: "profile.academic.score"))
                            NavigationCardView(destination: .credit, destinationName: String(localized: "profile.academic.credit"))
                        }
                        Text("profile.link")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 15) {
                            LinkCardView(link: "https://course.nuk.edu.tw/Sel/login.asp", linkName: String(localized: "profile.link.course"))
                            LinkCardView(link: "https://aca.nuk.edu.tw/Student2/login.asp", linkName: String(localized: "profile.link.affair"))
                        }
                        HStack(spacing: 15) {
                            LinkCardView(link: "https://sa.nuk.edu.tw/p/403-1009-419-1.php?Lang=zh-tw", linkName: String(localized: "profile.link.dorm"))
                            LinkCardView(link: "https://stu.nuk.edu.tw/eabsnew/login.asp", linkName: String(localized: "profile.link.dorm"))
                        }
                    }
                    .padding(15)
                }
            }
            .navigationTitle("profile.title")
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
                case PathDestination.privacy:
                    EmptyView()
                case PathDestination.contact:
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
