//
//  CourseInfoPopupView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/7.
//

import SwiftUI

struct CourseInfoPopupView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @State private var isUpdating: Bool = false
    private let semesterString: [String] = ["第一學期", "第二學期", "暑輔"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("課程資訊")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("DARK_GRAY"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let courseInfo = viewModel.courseInfo {
                HStack(spacing: 10) {
                    Text("目前版本")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(Color("DARK_GRAY"))
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("TAG_GRAY"))
                        )
                    Text("\(courseInfo.year)學年度\(semesterString[courseInfo.semester - 1]) [\(courseInfo.id.suffix(6))]")
                        .font(.system(size: 14))
                        .foregroundColor(Color("DARK_GRAY"))
                }
                HStack(spacing: 10) {
                    Text("上架時間")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(Color("DARK_GRAY"))
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("TAG_GRAY"))
                        )
                    Text("\(viewModel.getDateString(date: courseInfo.createdAt))")
                        .font(.system(size: 14))
                        .foregroundColor(Color("DARK_GRAY"))
                }
                HStack(spacing: 10) {
                    Text("更新時間")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(Color("DARK_GRAY"))
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("TAG_GRAY"))
                        )
                    Text("\(viewModel.getDateString(date: courseInfo.updatedAt))")
                        .font(.system(size: 14))
                        .foregroundColor(Color("DARK_GRAY"))
                }
                Button(action: {
                    Task {
                        isUpdating = true
                        await viewModel.getCourse()
                        isUpdating = false
                    }
                }, label: {
                    HStack(spacing: 10) {
                        Text("更新課程")
                            .font(.system(size: 16, design: .monospaced))
                            .fontWeight(.bold)
                        if isUpdating {
                            ProgressView()
                                .scaleEffect(0.7)
                                .padding(-5)
                        }
                    }
                    .foregroundColor(Color("WHITE"))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("YELLOW"))
                    )
                })
                .disabled(isUpdating)
            } else {
                Text("您尚未獲取任何課程")
                    .font(.system(size: 16))
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 50)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("WHITE"))
        )
        .padding(25)
    }
}

struct CourseInfoPopupView_Previews: PreviewProvider {
    static let viewModel: CourseViewModel = CourseViewModel()
    static var previews: some View {
        CourseInfoPopupView()
            .previewLayout(.sizeThatFits)
            .environmentObject(viewModel)
            .task {
                await viewModel.getCourseIfNeeded()
            }
    }
}
