//
//  AuthorScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/8.
//

import SwiftUI

struct AuthorScreen: View {
    @State private var openSafariHaoQuanLiu: Bool = false
    @State private var openSafariZiEnShao: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            VStack(spacing: 15) {
                Button(action: {
                    openSafariHaoQuanLiu = true
                }, label: {
                    HStack(spacing: 10) {
                        Image("劉顥權")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(Color("COURSE_RED"))
                        Divider()
                            .frame(height: 32)
                        HStack(spacing: 10) {
                            Image("男")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("劉顥權 Hao-Quan Liu")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("DARK_GRAY"))
                                Text("國立中興大學資訊工程學系")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("DARK_GRAY"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 12)
                                .foregroundStyle(Color("DARK_GRAY"))
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("WHITE"))
                            .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                    )
                })
                .fullScreenCover(isPresented: $openSafariHaoQuanLiu, content: {
                    SafariView(url: URL(string: "https://haoquan.me")!)
                        .edgesIgnoringSafeArea(.all)
                })
                Button(action: {
                    openSafariZiEnShao = true
                }, label: {
                    HStack(spacing: 10) {
                        Image("邵子恩")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(Color("COURSE_RED"))
                        Divider()
                            .frame(height: 32)
                        HStack(spacing: 10) {
                            Image("女")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("邵子恩 Zi-En Shao")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("DARK_GRAY"))
                                Text("國立高雄大學工藝與創意設計學系")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("DARK_GRAY"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        }
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .foregroundStyle(Color("DARK_GRAY"))
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("WHITE"))
                            .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                    )
                })
                .fullScreenCover(isPresented: $openSafariZiEnShao, content: {
                    SafariView(url: URL(string: "https://drive.google.com/file/d/1Vo2nePUU7NEcLd3gOOJFP0b7L-n2sOBs/view?usp=sharing")!)
                        .edgesIgnoringSafeArea(.all)
                })
            }
            .padding(15)
        }
        .navigationTitle("作者資訊")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AuthorScreen()
}
