//
//  CourseCategoryView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/9/14.
//

import SwiftUI

struct CourseCategoryView<T: CreditCategorizable>: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @EnvironmentObject private var popupManager: PopupManager
    private var targetItems: [T] {
        if courseCategory == .all {
            return items
        } else {
            return items.filter { $0.getCourseCategory().getParent() == courseCategory }
        }
    }
    private var targetCredit: Double {
        targetItems.reduce(0) { $0 + $1.credit }
    }
    let items: [T]
    let courseCategory: CourseCategory
    let popupBuilder: (CourseCategory, [T]) -> AnyView
//    let requiredCredit: Double? = nil
//    let requiredDimension: Int? = nil
    
    init(courses: [Course], courseCategory: CourseCategory) where T == Course {
            self.items = courses
            self.courseCategory = courseCategory
            self.popupBuilder = { category, filtered in
                AnyView(CourseCategoryPopupView(courseCategory: category, targetCourses: filtered))
            }
        }
        
    init(grades: [Grade], courseCategory: CourseCategory) where T == Grade {
        self.items = grades
        self.courseCategory = courseCategory
        self.popupBuilder = { category, filtered in
            AnyView(EmptyView()) // GradeCategoryPopupView(courseCategory: category, targetGrades: filtered)
        }
    }
    
    var body: some View {
        Button(action: {
            popupManager.set(popup: AnyView(
                popupBuilder(courseCategory, targetItems)
                    .environmentObject(viewModel)
            ))
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
                    Text("\(targetCredit.formatted(.number))")
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
                
//                Text("需 \(requiredCredit == nil ? "--" : String(requiredCredit!.formatted(.number))) 學分")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("DARK_GRAY"))
//                    .padding(5)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .foregroundColor(Color("TAG_GRAY"))
//                    )
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(10)
            .frame(height: 150)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color("WHITE"))
                    .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            )
        })
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CourseCategoryView(courses: [], courseCategory: CourseCategory.requiredTogether)
}
