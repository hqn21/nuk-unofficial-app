//
//  CourseDraftView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/6.
//

import SwiftUI
import OSLog

struct CourseDraftView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @EnvironmentObject private var popupManager: PopupManager
    @State private var departmentSelected: Department? = nil
    @State private var programSelected: Program? = nil
    @State private var gradeSelected: Int = 0
    private let gradeString: [String] = ["全", "一", "二", "三", "四", "五"]
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                Menu {
                    Button(action: {
                        programSelected = nil
                    }, label: {
                        Text("所有部別")
                    })
                    ForEach(viewModel.program) { program in
                        Button(action: {
                            programSelected = program
                        }, label: {
                            Text("\(program.name)")
                        })
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("\(programSelected != nil ? programSelected!.name : "所有部別")")
                            .font(.system(size: 15))
                            .foregroundColor(Color("DARK_GRAY"))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color("DARK_GRAY"))
                    }
                    .padding(10)
                    .frame(height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("WHITE"))
                            .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                    )
                }
                Menu {
                    ForEach(0...5, id: \.self) { index in
                        Button(action: {
                            gradeSelected = index
                        }, label: {
                            Text("\(gradeString[index])年級")
                        })
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("\(gradeString[gradeSelected])年級")
                            .font(.system(size: 15))
                            .foregroundColor(Color("DARK_GRAY"))
                        
                        Spacer()
                        
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color("DARK_GRAY"))
                    }
                    .padding(10)
                    .frame(width: 95, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("WHITE"))
                            .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                    )
                }
            }
            Menu {
                Button(action: {
                    departmentSelected = nil
                }, label: {
                    Text("所有系所")
                })
                ForEach(viewModel.department) { department in
                    Button(action: {
                        departmentSelected = department
                    }, label: {
                        Text("\(department.name)")
                    })
                }
            } label: {
                HStack(spacing: 0) {
                    Text("\(departmentSelected != nil ? departmentSelected!.name : "所有系所")")
                        .font(.system(size: 15))
                        .foregroundColor(Color("DARK_GRAY"))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("DARK_GRAY"))
                }
                .padding(10)
                .frame(height: 35)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("WHITE"))
                        .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                )
            }
            
            if viewModel.course.isEmpty {
                ProgressView()
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("WHITE"))
                        .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.course) { course in
                                if (departmentSelected == nil || course.departmentIdRecommended == departmentSelected!.id), (programSelected == nil || course.programId == programSelected!.id), (gradeSelected == 0 || course.grade == gradeSelected) {
                                    HStack(spacing: 10) {
                                        Button(action: {
                                            if viewModel.isSelected(course: course) {
                                                viewModel.unselectCourse(course: course)
                                            } else {
                                                viewModel.selectCourse(course: course)
                                            }
                                        }, label: {
                                            Image(systemName: viewModel.isSelected(course: course) ? "checkmark.square" : "square")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(Color(viewModel.canClick(course: course) ? "DARK_GRAY" : "LITTLE_DARK_GRAY"))
                                        })
                                        .disabled(!viewModel.canClick(course: course))
                                        VStack(alignment: .leading, spacing: 0) {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                Text("\(course.name)")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color("DARK_GRAY"))
                                            }
                                            Text("\(course.teacher ?? "待公布")")
                                                .font(.system(size: 12, design: .monospaced))
                                                .foregroundColor(Color("DARK_GRAY"))
                                                .lineLimit(1)
                                        }
                                        Group {
                                            if course.departmentId != "CC" {
                                                Text("\(course.courseType)\(course.credit.formatted(.number))/\(course.getTimeString())")
                                            } else {
                                                Text("\(course.getCourseCategoryName())/\(course.getTimeString())")
                                            }
                                        }
                                        .font(.system(size: 12, design: .monospaced))
                                        .foregroundColor(Color("DARK_GRAY"))
                                        .frame(alignment: .trailing)
                                        .lineLimit(1)
                                        Button(action: {
                                            popupManager.set(popup: AnyView(
                                                CoursePopupView(course: course)
                                                    .environmentObject(viewModel)
                                            ))
                                        }, label: {
                                            Image(systemName: "info.circle")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(Color("DARK_GRAY"))
                                        })
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    Divider()
                                        .padding(.horizontal, 10)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 15)
            }
        }
        .padding(.horizontal, 25)
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
    }
}

struct CourseDraftView_Previews: PreviewProvider {
    static let viewModel: CourseViewModel = CourseViewModel()
    static var previews: some View {
        CourseDraftView()
            .previewLayout(.sizeThatFits)
            .environmentObject(viewModel)
            .environmentObject(PopupManager())
            .task {
                await viewModel.getCourseIfNeeded()
            }
    }
}
