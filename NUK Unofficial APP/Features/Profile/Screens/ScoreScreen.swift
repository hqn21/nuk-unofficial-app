//
//  ScoreScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct ScoreScreen: View {
    @EnvironmentObject private var popupManager: PopupManager
    @EnvironmentObject private var viewModel: CourseViewModel
    @State private var targetSemester: Semester? = nil
    @State private var targetSemesterGrade: SemesterGrade? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
                .ignoresSafeArea(edges: .bottom)
            VStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("WHITE"))
                        .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                        .frame(height: 35)
                    Menu {
                        if let transcriptConfirmed = viewModel.transcriptConfirmed {
                            ForEach(viewModel.getSemesterList(semesterGrades: transcriptConfirmed.semesterGrades)) { semester in
                                Button(action: {
                                    targetSemester = semester
                                    targetSemesterGrade = viewModel.getSemesterGrade(semester: semester)
                                }, label: {
                                    Text(viewModel.getSemesterName(semester: semester))
                                })
                            }
                        }
                    } label: {
                        HStack(spacing: 0) {
                            Group {
                                if viewModel.transcriptConfirmed == nil {
                                    Text("請先匯入成績")
                                } else if let targetSemester = targetSemester {
                                    Text(viewModel.getSemesterName(semester: targetSemester))
                                } else if viewModel.transcriptConfirmed!.semesterGrades.count == 0 {
                                    Text("您目前沒有任何可查詢的成績")
                                } else {
                                    Text("請選擇想查詢的學期")
                                }
                            }
                            .font(.system(size: 15))
                            .foregroundColor(Color("DARK_GRAY"))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color("DARK_GRAY"))
                        }
                        .padding(10)
                        .frame(height: 35)
                    }
                    .disabled(viewModel.transcriptConfirmed == nil)
                }
                .padding([.top, .horizontal], 15)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            VStack(spacing: 10) {
                                Text("全班排名")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("DARK_GRAY"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if let targetSemesterGrade = targetSemesterGrade {
                                    if let rank = targetSemesterGrade.rank {
                                        if rank <= 3 {
                                            Image("rank_\(rank)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: .infinity, alignment: .center)
                                        } else {
                                            Text("\(rank)")
                                                .font(.system(size: 40, design: .monospaced))
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("DARK_GRAY"))
                                                .frame(maxHeight: .infinity, alignment: .center)
                                        }
                                    } else {
                                        Text("--")
                                            .font(.system(size: 40, design: .monospaced))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("DARK_GRAY"))
                                            .frame(maxHeight: .infinity, alignment: .center)
                                    }
                                } else {
                                    Text("--")
                                        .font(.system(size: 40, design: .monospaced))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("DARK_GRAY"))
                                        .frame(maxHeight: .infinity, alignment: .center)
                                }
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("WHITE"))
                                    .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                            )
                            
                            VStack(spacing: 10) {
                                Text("平均成績")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("DARK_GRAY"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(targetSemesterGrade?.averageScore.map { String(format: "%g", $0) } ?? "--")
                                    .font(.system(size: 40, design: .monospaced))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("DARK_GRAY"))
                                    .frame(maxHeight: .infinity, alignment: .center)
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("WHITE"))
                                    .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                            )
                        }
                        .frame(height: 120)
                        
                        GradeView(grades: targetSemesterGrade?.grades.filter { $0.courseType == "必" } ?? [], courseType: "必")
                        GradeView(grades: targetSemesterGrade?.grades.filter { $0.courseType == "選" } ?? [], courseType: "選")
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 15)
                }
            }
            .task {
                await viewModel.getDepartmentIfNeeded()
            }
            .onAppear {
                viewModel.loadTranscriptConfirmed()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    popupManager.set(popup: AnyView(
                        GradePopupView()
                    ))
                }, label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "questionmark.circle.fill")
                    }
                })
            }
        }
        .navigationTitle("成績查詢")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ScoreScreen()
        .environmentObject(PopupManager())
        .environmentObject(CourseViewModel())
}
