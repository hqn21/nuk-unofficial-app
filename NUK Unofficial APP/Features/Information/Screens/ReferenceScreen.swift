//
//  ReferenceScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/8.
//

import SwiftUI

struct ReferenceCellView: View {
    let name: String
    let content: String
    let imageName: String
    let urlString: String
    @State private var openSafari: Bool = false
    
    var body: some View {
        Button(action: {
            openSafari = true
        }, label: {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    ZStack(alignment: .center) {
                        Color("LITTLE_DARK_GRAY")
                        Image(systemName: "\(imageName)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("WHITE"))
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(content)")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                        Text("\(name)")
                            .font(.system(size: 22, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color("WHITE"))
                    .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            )
            .fullScreenCover(isPresented: $openSafari, content: {
                SafariView(url: URL(string: "\(urlString)")!)
                    .edgesIgnoringSafeArea(.all)
            })
        })
    }
}

struct ReferenceScreen: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ReferenceCellView(name: "天氣資訊", content: "交通部中央氣象局", imageName: "cloud.fill", urlString: "https://www.cwa.gov.tw/")
                    ReferenceCellView(name: "空氣資訊", content: "行政院環境保護署", imageName: "facemask.fill", urlString: "https://www.epa.gov.tw/")
                    ReferenceCellView(name: "Youbike 站點資訊", content: "YouBike微笑單車", imageName: "bicycle", urlString: "https://www.youbike.com.tw/")
                    ReferenceCellView(name: "高大公告資訊", content: "國立高雄大學", imageName: "megaphone.fill", urlString: "https://www.nuk.edu.tw/p/403-1000-112-1.php?Lang=zh-tw")
                    ReferenceCellView(name: "高大課程資訊", content: "國立高雄大學", imageName: "calendar.badge.clock", urlString: "https://course.nuk.edu.tw/QueryCourse/QueryCourse.asp")
                    ReferenceCellView(name: "其它高大相關資訊", content: "國立高雄大學", imageName: "graduationcap.fill", urlString: "https://www.nuk.edu.tw/")
                    ReferenceCellView(name: "部分圖示", content: "Flaticon", imageName: "scribble.variable", urlString: "https://www.flaticon.com/")
                }
                .padding(15)
            }
        }
        .navigationTitle("資料來源")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ReferenceScreen()
}
