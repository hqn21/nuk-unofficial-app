//
//  TimetableDraftView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/6.
//

import SwiftUI

struct TimetableDraftView: View {
    @EnvironmentObject private var viewModel: CourseViewModel
    @State private var timetableType: TimetableType = .normal
    let timetableTypeString: [String] = ["完整", "簡略"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Menu {
                    ForEach(0...1, id: \.self) { i in
                        Button(action: {
                            timetableType = .init(rawValue: i)!
                        }, label: {
                            Text("\(timetableTypeString[i])")
                        })
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("\(timetableTypeString[timetableType.rawValue])")
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
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 10)
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    TimetableView(timetableType: $timetableType, timetable: viewModel.timetable)
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
