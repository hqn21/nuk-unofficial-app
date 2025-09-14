//
//  TimetableView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

enum TimetableType: Int, Codable {
    case normal = 0
    case simplified = 1
}

struct TimetableCellView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @EnvironmentObject private var popupManager: PopupManager
    let course: Course?
    let courseWidth: CGFloat
    let courseHeight: CGFloat
    let timetableType: TimetableType
    
    var body: some View {
        // 每個課程
        VStack(spacing: 0) {
            // 課程類別顏色
            VStack(spacing: 0) {
            }
            .frame(width: courseWidth, height: 14)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(course?.getCourseCategory().getColor() ?? Color("LITTLE_DARK_GRAY"))
            )
            
            // 課程類別顏色
            VStack(spacing: 0) {
            }
            .frame(width: courseWidth, height: 7)
            .background(
                Rectangle()
                    .foregroundColor(course?.getCourseCategory().getColor() ?? Color("LITTLE_DARK_GRAY"))
            )
            .offset(y: -7)
            
            // 課程名稱
            Button(action: {
                if let course = course {
                    popupManager.set(popup: AnyView(
                        CoursePopupView(course: course)
                            .environmentObject(viewModel)
                    ))
                }
            }, label: {
                VStack(spacing: 0) {
                    if let course = course {
                        if timetableType == .normal {
                            Text("\(course.name)")
                                .font(.system(size: 10))
                                .foregroundColor(Color("DARK_GRAY"))
                                .multilineTextAlignment(.center)
                                .padding(3)
                                .padding(.top, -7)
                            Spacer()
                            Text("\(course.classroom ?? "未公佈")")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color("DARK_GRAY"))
                                .padding(3)
                        } else {
                            Text("\(course.name[0..<2])")
                                .font(.system(size: 12))
                                .foregroundColor(Color("DARK_GRAY"))
                                .multilineTextAlignment(.center)
                                .padding(3)
                                .padding(.top, -7)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                    } else {
                        Text("")
                            .font(.system(size: 12))
                            .foregroundColor(Color("DARK_GRAY"))
                            .multilineTextAlignment(.center)
                            .padding(3)
                            .padding(.top, -7)
                            .frame(maxHeight: .infinity, alignment: .center)
                    }
                }
            })
        }
        .frame(width: courseWidth, height: courseHeight)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
        )
    }
}

struct TimetableView: View {
    let timetableType: TimetableType
    let timetable: [[Course?]]
    let courseWidth: [CGFloat] = [60, 50]
    let courseHeight: [CGFloat] = [100, 50]
    let coursePeriod: [String] = ["X", "1", "2", "3", "4", "Y", "5", "6", "7", "8", "9", "10", "11", "12", "13"]
    let dayName: [String] = ["一", "二", "三", "四", "五", "六", "日"]
    
    var body: some View {
        ZStack {
            // 節次
            VStack(spacing: 10) {
                // 替代星期的 Spacer
                Spacer()
                    .frame(height: 30)
                
                ForEach(0..<15, id: \.self) { index in
                    HStack(spacing: 0) {
                        Text("\(coursePeriod[index])")
                            .font(.system(size: 16, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TIMETABLE_LITTLE_DARK_GRAY"))
                        Spacer()
                            .frame(width: 85 + courseWidth[timetableType.rawValue] * 7)
                        
                    }
                    .frame(height: courseHeight[timetableType.rawValue])
                }
            }
            
            VStack(spacing: 10) {
                // 星期
                HStack(spacing: 10) {
                    ForEach(0..<7, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("WHITE"))
                                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                            Text("\(timetableType.rawValue == 0 ? "星期" : "")\(dayName[index])")
                                .font(.system(size: 12))
                                .foregroundColor(Color("DARK_GRAY"))
                                .frame(width: courseWidth[timetableType.rawValue], height: 30)
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                HStack(spacing: 10) {
                    ForEach(0..<7, id: \.self) { i in
                        VStack(spacing: 10) {
                            ForEach(0..<15, id: \.self) { k in
                                TimetableCellView(course: timetable[i][k], courseWidth: courseWidth[timetableType.rawValue], courseHeight: courseHeight[timetableType.rawValue], timetableType: timetableType)
                            }
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 25)
        }
        .padding(.top, 2)
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        @State var timetableType: TimetableType = .normal
        
        TimetableView(timetableType: timetableType, timetable: [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7))
            .previewLayout(.sizeThatFits)
            .environmentObject(CourseViewModel())
            .environmentObject(PopupManager())
    }
}
