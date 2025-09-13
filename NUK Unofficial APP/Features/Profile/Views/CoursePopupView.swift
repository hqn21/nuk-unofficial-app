//
//  CoursePopupView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/9/13.
//

import SwiftUI

struct CourseMetadataView: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text("\(title)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(Color("DARK_GRAY"))
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("TAG_GRAY"))
                )
            Text("\(content)")
                .font(.system(size: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CourseEnrollmentView: View {
    let title: String
    let counter: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(title)")
                .font(.system(size: 14))
                .foregroundColor(Color("DARK_GRAY"))
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("TAG_GRAY"))
                )
            HStack(alignment: .firstTextBaseline) {
                Text("\(counter == nil ? "--" : "\(String(describing: counter!))")")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 42))
                Text("人")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CoursePopupView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @State private var selection: Int = 0
    @State private var openSafari: Bool = false
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "rectangle.portrait.fill")
                    .resizable()
                    .frame(width: 6, height: 16)
                    .foregroundColor(course.getCourseCategoryColor())
                Text("\(course.name)")
                    .font(.system(size: 18))
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    openSafari = true
                }, label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("DARK_GRAY"))
                        .frame(width: 18, height: 18)
                })
                .fullScreenCover(isPresented: $openSafari, content: {
                    SafariView(url: URL(string: viewModel.getCourseWebsite(course: course))!)
                        .edgesIgnoringSafeArea(.all)
                })
            }
            Picker("呈現模式", selection: $selection) {
                Text("課程資訊")
                    .tag(0)
                Text("即時人數")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            VStack(spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    CourseMetadataView(title: "課號", content: "\(course.departmentId)\(course.courseCode)")
                    CourseMetadataView(title: "老師", content: "\(course.teacher ?? "未公佈")")
                }
                HStack(alignment: .top, spacing: 10) {
                    CourseMetadataView(title: "部別", content: "\(viewModel.getProgramName(id: course.programId) ?? "未知")")
                    CourseMetadataView(title: "選課", content: "\(viewModel.getDepartmentName(id: course.departmentIdRecommended) ?? "未知")")
                }
                HStack(alignment: .top, spacing: 10) {
                    CourseMetadataView(title: "系所", content: "\(viewModel.getDepartmentName(id: course.departmentId) ?? "未知")")
                    CourseMetadataView(title: "分類", content: "\(course.getCourseCategoryName())")
                }
                HStack(alignment: .top, spacing: 10) {
                    CourseMetadataView(title: "年級", content: "\(course.grade)")
                    CourseMetadataView(title: "班級", content: "\(course.section ?? "未公佈")")
                }
                HStack(alignment: .top, spacing: 10) {
                    CourseMetadataView(title: "修別", content: "\(course.courseType)")
                    CourseMetadataView(title: "學分", content: "\(course.credit.formatted(.number))")
                }
                HStack(alignment: .top, spacing: 10) {
                    CourseMetadataView(title: "教室", content: "\(course.classroom ?? "未公佈")")
                    CourseMetadataView(title: "時間", content: "\(course.getTimeString())")
                }
                CourseMetadataView(title: "備註", content: "\(course.note ?? "未公佈")")
            }
            .overlay(
                Color("WHITE")
                    .opacity(selection == 1 ? 1 : 0)
            )
            .overlay(
                Group {
                    if selection == 1 {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 5) {
                                Image(systemName: "\(viewModel.getCourseEnrollmentStatusIconName())")
                                    .foregroundColor(Color("WHITE"))
                                Text("\(viewModel.getCourseEnrollmentStatusMessage())")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("WHITE"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(viewModel.getCourseEnrollmentStatusColor())
                            )
                            HStack(alignment: .top, spacing: 0) {
                                CourseEnrollmentView(title: "限修人數", counter: viewModel.courseEnrollment?.enrollmentLimit)
                                CourseEnrollmentView(title: "選課確定", counter: viewModel.courseEnrollment?.enrollment)
                            }
                            HStack(alignment: .top, spacing: 0) {
                                CourseEnrollmentView(title: "線上人數", counter: viewModel.courseEnrollment?.enrollmentPending)
                                CourseEnrollmentView(title: "課程餘額", counter: viewModel.courseEnrollment?.enrollmentAvailable)
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .task {
                            await viewModel.getCourseEnrollment(id: course.id)
                        }
                    }
                }
            )
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
    let viewModel: CourseViewModel = CourseViewModel()
    CoursePopupView(course: Course(id: "test", programId: "A", departmentId: "CS", departmentIdRecommended: "CS", name: "測試課程", courseCode: "1234", courseType: "必", credit: 2.5, grade: 3))
        .environmentObject(viewModel)
        .task {
            await viewModel.getCourseIfNeeded()
            await viewModel.getDepartmentIfNeeded()
            await viewModel.getProgramIfNeeded()
        }
}
