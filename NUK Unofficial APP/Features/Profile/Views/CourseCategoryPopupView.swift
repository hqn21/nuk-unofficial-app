//
//  CourseCategoryPopupView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/9/14.
//

import SwiftUI

struct CourseCategoryPopupView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @EnvironmentObject private var popupManager: PopupManager
    let courseCategory: CourseCategory
    let targetCourses: [Course]
    let requiredCredit: Double? = nil
    let requiredDimension: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "rectangle.portrait.fill")
                    .resizable()
                    .frame(width: 6, height: 16)
                    .foregroundColor(courseCategory.getColor())
                Text("\(courseCategory.getName())")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
//                HStack(spacing: 10) {
//                    if let requiredCredit = requiredCredit {
//                        Text("需 \(requiredCredit.formatted(.number)) 學分")
//                            .font(.system(size: 12))
//                            .foregroundColor(Color("DARK_GRAY"))
//                            .padding(5)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .foregroundColor(Color("TAG_GRAY"))
//                            )
//                    }
//                    if let requiredDimension = requiredDimension {
//                        Text("需 \(requiredDimension.formatted(.number)) 向度")
//                            .font(.system(size: 12))
//                            .foregroundColor(Color("DARK_GRAY"))
//                            .padding(5)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .foregroundColor(Color("TAG_GRAY"))
//                            )
//                    }
//                    if requiredCredit == nil && requiredDimension == nil {
//                        Text("無規定")
//                            .font(.system(size: 12))
//                            .foregroundColor(Color("DARK_GRAY"))
//                            .padding(5)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .foregroundColor(Color("TAG_GRAY"))
//                            )
//                    }
//                }
            }
            VStack(alignment: .leading, spacing: 10) {
                if targetCourses.isEmpty {
                    Text("\(courseCategory == .all ? "您目前沒有勾選任何課程" : "您目前沒有勾選任何「\(courseCategory.getName())」的課程")")
                        .font(.system(size: 16))
                        .foregroundColor(Color("DARK_GRAY"))
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    switch courseCategory {
                    default:
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 5) {
                                ForEach(targetCourses) { course in
                                    Button(action: {
                                        popupManager.dismiss()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            popupManager.set(popup: AnyView(
                                                CoursePopupView(course: course)
                                                    .environmentObject(viewModel)
                                            ))
                                        }
                                    }, label: {
                                        HStack(spacing: 10) {
                                            VStack(alignment: .leading, spacing: 0) {
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    Text("\(course.name)")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(Color("DARK_GRAY"))
                                                }
                                                Text("\(course.teacher ?? "未公佈")")
                                                        .font(.system(size: 12, design: .monospaced))
                                                        .foregroundColor(Color("DARK_GRAY"))
                                                        .lineLimit(1)
                                            }
                                            Text("\(course.credit.formatted(.number))學分/\(course.departmentId)\(course.courseCode)")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundColor(Color("DARK_GRAY"))
                                                    .fixedSize(horizontal: true, vertical: false)
                                                    .frame(alignment: .trailing)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    })
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
            .frame(height: 300)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("WHITE"))
        )
        .padding(25)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CourseCategoryPopupView(courseCategory: .requiredTogether, targetCourses: [])
}
