//
//  TimetableScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct TimetableScreen: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    let timetableTypeString: [String] = ["完整", "簡略"]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            VStack(spacing: 0) {
//                HStack(spacing: 10) {
//                    Button(action: {
////                                            getTimetableFromAccount()
//                    }, label: {
//                        HStack(spacing: 0) {
//                            Text("重新取得課表")
//                                .font(.system(size: 15))
//                                .foregroundColor(Color("DARK_GRAY"))
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
//                        .frame(height: 35)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .foregroundColor(Color("WHITE"))
//                                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
//                        )
//                    })
//                }
                HStack(spacing: 10) {
                    Button(action: {
                        viewModel.resetCourseConfirmed()
                    }, label: {
                        HStack(spacing: 0) {
                            Text("清除匯入課程")
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
                        viewModel.saveTimetable(timetableType: viewModel.timetableType, timetable: viewModel.timetableConfirmed)
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
                .padding(.vertical, 10)
                .padding(.horizontal, 25)
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        TimetableView(timetableType: viewModel.timetableType, timetable: viewModel.timetableConfirmed)
                    }
                }
            }
            .alert(
                "個人課表",
                isPresented: $viewModel.showAlert,
                actions: {
                    Button("確認", action: {})
                },
                message: {
                    Text("\(viewModel.alertMessage ?? "未知錯誤")")
                }
            )
            .onAppear() {
                viewModel.loadCourseConfirmed()
                viewModel.loadTimetableType()
            }
        }
        .navigationTitle("個人課表")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TimetableScreen()
        .environmentObject(CourseViewModel())
}
