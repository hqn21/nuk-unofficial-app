//
//  TimetablePopup.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/9/18.
//

import SwiftUI

struct TimetablePopup: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("匯入課程教學")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("DARK_GRAY"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("1")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("前往個人頁面中的課程查詢")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
            }
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("2")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("點擊右上角的齒輪，確認目前版本符合當前學期")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
            }
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("3")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("回到個人頁面，點擊快速連結中的選課系統")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
            }
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("4")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("登入您的帳號")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
            }
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("5")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("點擊選課結果查詢")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
            }
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("6")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("點擊下方列表中的")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .foregroundColor(Color("DARK_GRAY"))
            }
            HStack(alignment: .center, spacing: 5) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DARK_GRAY"))
                    Text("7")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color("WHITE"))
                }
                Text("點擊匯入課表")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color("DARK_GRAY"))
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("WHITE"))
        )
        .padding(25)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TimetablePopup()
}
