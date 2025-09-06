//
//  DonationScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/8.
//

import SwiftUI

struct DonationScreen: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("GRAY")
            VStack(spacing: 15) {
                HStack(spacing: 10) {
                    Image(systemName: "app.gift.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(Color("COURSE_RED"))
                    Divider()
                        .frame(height: 48)
                    HStack(spacing: 10) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .cornerRadius(11.2)
                            .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(verbatim: "NUK Unofficial APP")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(Color("DARK_GRAY"))
                            Text(verbatim: "整合高大學生日常資訊")
                                .font(.system(size: 14))
                                .foregroundColor(Color("DARK_GRAY"))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("WHITE"))
                        .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(verbatim: "NUK Unofficial APP 是由國立高雄大學學生自主開發的免費校園應用程式，我們的開發團隊由資訊工程學系與工藝與創意設計學系的學生組成，旨在整合校園日常資訊與教務系統功能，提升學生的校園生活體驗。")
                    Text(verbatim: "為了持續維護和改進這款免費且由學生自主開發的應用程式，我們誠摯地邀請您提供贊助與支持，雖然贊助不會帶來直接的回報，但您的支持將對我們意義重大，幫助我們持續為高大學生提供優質的免費服務。")
                    Text(verbatim: "※ 贊助金額由贊助者自行填寫\n※ 若有任何疑問請透過問題回報聯繫我們")
                }
                .font(.system(size: 16))
                .foregroundColor(Color("DARK_GRAY"))
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("WHITE"))
                        .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
                )
                
                DonationButtonView(goView: false)
            }
            .padding(15)
        }
        .navigationTitle("贊助我們")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DonationScreen()
}
