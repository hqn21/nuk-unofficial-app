//
//  GradeView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2026/3/2.
//

import SwiftUI

struct GradeView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    let grades: [Grade]
    let courseType: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text("\(courseType)修課程")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                Spacer()
                Text("\(String(format: "%g", viewModel.getCompletedCredit(grades: grades)))/\(String(format: "%g", viewModel.getTotalCredit(grades: grades)))")
                    .font(.system(size: 16, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
            }
            
            ForEach(grades) { grade in
                HStack(spacing: 0) {
                    Image(systemName: "rectangle.portrait.fill")
                        .resizable()
                        .frame(width: 6, height: 28)
                        .foregroundColor(grade.getColor())
                        .padding(.trailing, 10)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(grade.name)
                            .font(.system(size: 14))
                        Text("\(String(format: "%g", grade.credit))學分｜期中成績\(grade.midterm == nil ? "未送分" : "\(grade.midterm!)分")")
                            .font(.system(size: 12))
                    }
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(grade.final?.description ?? "--")
                            .font(.system(size: 26))
                        Text("分")
                            .font(.system(size: 14))
                    }
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
        )
    }
}

#Preview {
    GradeView(grades: [], courseType: "必")
        .environmentObject(CourseViewModel())
}
