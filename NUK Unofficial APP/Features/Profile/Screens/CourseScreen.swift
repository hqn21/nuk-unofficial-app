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
    @EnvironmentObject private var popupManager: PopupManager
    @EnvironmentObject private var viewModel: CourseViewModel
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
                        .environmentObject(viewModel)
                case .credit:
                    CreditDraftView()
                        .environmentObject(viewModel)
                }
            }
            .alert(
                "課程查詢",
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
        }
        .onAppear() {
            viewModel.loadCourseSelected()
            viewModel.loadTimetableType()
        }
        .task {
            await viewModel.getCourseIfNeeded()
            await viewModel.getProgramIfNeeded()
            await viewModel.getDepartmentIfNeeded()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    popupManager.set(popup: AnyView(
                        CourseInfoPopupView()
                            .environmentObject(viewModel)
                    ))
                }, label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "gearshape.fill")
                        if viewModel.hasUpdate {
                            Text("!")
                                .font(.caption2)
                                .foregroundColor(Color("WHITE"))
                                .padding(5)
                                .background(Color("YELLOW"))
                                .clipShape(Circle())
                                .padding(2)
                                .background(Color("WHITE"))
                                .clipShape(Circle())
                                .offset(x: 7, y: -11)
                        }
                    }
                })
            }
        }
        .navigationTitle("課程查詢")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CourseScreen()
        .environmentObject(PopupManager())
}
