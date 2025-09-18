//
//  LinkCardView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import SwiftUI

struct LinkCardView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    let link: String
    let linkName: String
    let linkImageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            VStack(spacing: 10) {
                Text("\(linkName)")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("\(linkImageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 64)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(10)
            .onTapGesture {
                viewModel.openSafari = true
            }
            .fullScreenCover(isPresented: $viewModel.openSafari, content: {
                SafariView(url: URL(string: "\(link)")!)
                    .edgesIgnoringSafeArea(.all)
            })
        }
    }
}

#Preview {
    LinkCardView(link: "https://sa.nuk.edu.tw/p/403-1009-419-1.php?Lang=zh-tw", linkName: "宿舍官網", linkImageName: "Dorm")
}
