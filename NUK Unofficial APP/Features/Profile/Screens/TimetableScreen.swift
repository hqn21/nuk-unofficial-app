//
//  TimetableScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct TimetableScreen: View {
    @State private var timetableType: TimetableType = .normal
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Button(action: {
//                                            getTimetableFromAccount()
                    }, label: {
                        HStack(spacing: 0) {
                            Text("重新取得課表")
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
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 25)
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        TimetableView(timetableType: $timetableType, timetable: [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7))
                    }
                }
            }
        }
        .navigationTitle("個人課表")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TimetableScreen()
}
