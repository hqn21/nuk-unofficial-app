//
//  TimetableDraftView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/6.
//

import SwiftUI
import UIKit
import Photos

struct TimetableDraftView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    let timetableTypeString: [String] = ["完整", "簡略"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Button(action: {
                    viewModel.resetCourseSelected()
                }, label: {
                    HStack(spacing: 0) {
                        Text("清除所選課程")
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
                })
                
                Menu {
                    ForEach(0...1, id: \.self) { i in
                        Button(action: {
                            viewModel.setTimetableType(timetableType: .init(rawValue: i)!)
                        }, label: {
                            Text("\(timetableTypeString[i])")
                        })
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("\(timetableTypeString[viewModel.timetableType.rawValue])")
                            .font(.system(size: 15))
                            .foregroundColor(Color("DARK_GRAY"))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color("DARK_GRAY"))
                    }
                    .padding(10)
                    .frame(width: 85, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("WHITE"))
                            .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                    )
                }
                Button(action: {
                    viewModel.saveTimetable(timetableType: viewModel.timetableType)
                }, label: {
                    Image(systemName: "arrow.down.square")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .foregroundColor(Color("DARK_GRAY"))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("WHITE"))
                                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                        )
                })
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 10)
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    TimetableView(timetableType: viewModel.timetableType, timetable: viewModel.timetable)
                        .padding(.vertical, 5)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "gearshape.fill")
                })
            }
        }
    }
}

#Preview {
    let viewModel = CourseViewModel()
    
    TimetableDraftView()
        .environmentObject(viewModel)
}
