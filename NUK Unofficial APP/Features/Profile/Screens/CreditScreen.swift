//
//  CreditScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct CreditScreen: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @State private var grades: [Grade] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
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
                .padding(.top, 15)
                .padding(.horizontal, 15)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        CourseCategoryView(grades: grades, courseCategory: .all)
                        CourseCategoryView(grades: grades, courseCategory: .requiredDepartment)
                        CourseCategoryView(grades: grades, courseCategory: .electiveDepartment)
                        CourseCategoryView(grades: grades, courseCategory: .requiredTogether)
                        CourseCategoryView(grades: grades, courseCategory: .electiveMain)
                        CourseCategoryView(grades: grades, courseCategory: .electiveSub)
                        CourseCategoryView(grades: grades, courseCategory: .electiveInterest)
                        CourseCategoryView(grades: grades, courseCategory: .other)
                        CourseCategoryView(grades: grades, courseCategory: .null)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 15)
                }
            }
            .onAppear {
                viewModel.loadTranscriptConfirmed()
                if let transcriptConfirmed = viewModel.transcriptConfirmed {
                    for semesterGrade in transcriptConfirmed.semesterGrades {
                        grades.append(contentsOf: semesterGrade.grades)
                    }
                }
            }
        }
        .navigationTitle("學分分析")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CreditScreen()
        .environmentObject(CourseViewModel())
}
