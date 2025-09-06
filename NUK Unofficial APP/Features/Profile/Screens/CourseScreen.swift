//
//  CourseScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

enum Draft {
    case course
    case timetable
    case credit
}

struct CourseScreen: View {
    @StateObject private var viewModel: CourseViewModel = CourseViewModel()
    @State private var selection: Draft = .course
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            VStack(spacing: 15) {
                Picker("課程查詢", selection: $selection) {
                    Text("勾選課程")
                        .tag(Draft.course)
                    Text("預覽課表")
                        .tag(Draft.timetable)
                    Text("學分統計")
                        .tag(Draft.credit)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 15)
                .padding(.horizontal, 25)
                
                switch selection {
                case .course:
                    CourseDraftView()
                        .environmentObject(viewModel)
                case .timetable:
                    TimetableDraftView()
                case .credit:
                    CreditDraftView()
                }
            }
            .alert(
                "課程查詢",
                isPresented: $viewModel.showAlert,
                actions: {
                    Button("確認", action: {})
                },
                message: {
                    Text("\(viewModel.alertMessage ?? "未知錯誤")")
                }
            )
        }
        .task {
            await viewModel.getCourseIfNeeded()
            await viewModel.getProgramIfNeeded()
            await viewModel.getDepartmentIfNeeded()
        }
        .navigationTitle("課程查詢")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CourseScreen()
}
