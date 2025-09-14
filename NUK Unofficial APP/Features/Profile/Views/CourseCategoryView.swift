//
//  CourseCategoryView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/9/14.
//

import SwiftUI

struct CourseCategoryView: View {
    @State var targetCourses: [Course] = []
    @State var targetCoursesCredit: Double = 0
    let courses: [Course]
    let courseCategory: CourseCategory
    let requiredCredit: Double? = nil
    let requiredDimension: Int? = nil
    
    var body: some View {
        Button(action: {
            
        }, label: {
            ZStack {
                HStack(spacing: 5) {
                    Image(systemName: "rectangle.portrait.fill")
                        .resizable()
                        .frame(width: 5, height: 18)
                        .foregroundColor(courseCategory.getColor())
                    Text("\(courseCategory.getName())")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color("DARK_GRAY"))
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text("\(targetCoursesCredit.formatted(.number))")
                        .font(.system(size: 40, design: .monospaced))
                        .foregroundColor(Color("DARK_GRAY"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("學分")
                        .font(.system(size: 20, design: .monospaced))
                        .foregroundColor(Color("DARK_GRAY"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(maxHeight: .infinity, alignment: .center)
                
                Text("需 \(requiredCredit == nil ? "--" : String(requiredCredit!.formatted(.number))) 學分")
                    .font(.system(size: 14))
                    .foregroundColor(Color("DARK_GRAY"))
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("TAG_GRAY"))
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(10)
            .frame(height: 150)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color("WHITE"))
                    .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            )
        })
        .onAppear() {
            targetCourses = []
            targetCoursesCredit = 0
            for course in courses {
                if course.getCourseCategory().getParent() == courseCategory {
                    targetCourses.append(course)
                    targetCoursesCredit += course.credit
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CourseCategoryView(courses: [], courseCategory: CourseCategory.requiredTogether)
}
