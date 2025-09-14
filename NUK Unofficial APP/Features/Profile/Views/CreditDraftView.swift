//
//  CreditDraftView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/6.
//

import SwiftUI

struct CreditDraftView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @EnvironmentObject private var popupManager: PopupManager
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 0) {
                Text("實際數據以高大官網為主")
                    .font(.system(size: 15))
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 35)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color("WHITE"))
                    .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            )
            .padding(.horizontal, 25)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 15) {
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .all)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .requiredDepartment)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .electiveDepartment)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .requiredTogether)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .electiveMain)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .electiveSub)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .electiveInterest)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .other)
                    CourseCategoryView(courses: viewModel.courseSelected, courseCategory: .null)
                }
                .padding(.top, 2)
                .padding(.bottom, 15)
                .padding(.horizontal, 25)
            }
        }
    }
}

#Preview {
    CreditDraftView()
        .environmentObject(CourseViewModel())
        .environmentObject(PopupManager())
}
