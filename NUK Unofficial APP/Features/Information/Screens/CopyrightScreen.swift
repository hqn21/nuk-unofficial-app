//
//  CopyrightScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/8.
//

import SwiftUI

struct CopyrightScreen: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            ScrollView(.vertical, showsIndicators: false) {
                Text("NUK Unofficial APP 是由 Hao-Quan Liu 個人運營之非官方 App，與國立高雄大學無任何形式上的合作關係。另外，此 App 中與國立高雄大學的相關內容僅供參考，實際內容以國立高雄大學官網公告為主。")
                    .font(.system(size: 16))
                    .foregroundStyle(Color("DARK_GRAY"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("WHITE"))
                    )
                    .padding(15)
            }
        }
        .navigationTitle("版權聲明")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CopyrightScreen()
}
