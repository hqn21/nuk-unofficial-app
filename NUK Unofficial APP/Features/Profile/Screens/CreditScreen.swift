//
//  CreditScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct CreditScreen: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text("Hello World")
                }
            }
        }
        .navigationTitle("學分分析")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CreditScreen()
}
