//
//  BroadcastItemView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import SwiftUI

struct BroadcastItemView: View {
    @EnvironmentObject private var viewModel: BroadcastViewModel
    @State private var openSafari: Bool = false
    let broadcast: Broadcast
    let isPlaceholder: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if isPlaceholder {
                Image(systemName: "square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .foregroundColor(Color("DARK_GRAY"))
                    .padding(2)
            } else {
                Text(("\(broadcast.author)"[0]).uppercased())
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(width: 32, height: 32)
                    .padding(2)
                    .background(Color("BROADCAST_COLOR"))
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: "\(viewModel.getDateString(date: broadcast.dateTime)) \(broadcast.author)")
                    .font(.system(size: 12))
                    .foregroundColor(Color("DARK_GRAY"))
                Text(verbatim: "\(broadcast.title)")
                    .font(.system(size: 16))
                    .foregroundColor(Color("DARK_GRAY"))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        if !isPlaceholder {
                            openSafari = true
                        }
                    }
                    .fullScreenCover(isPresented: $openSafari, content: {
                        SafariView(url: URL(string: "\(broadcast.url)")!)
                            .edgesIgnoringSafeArea(.all)
                    })
            }
        }
        .redacted(reason: isPlaceholder ? .placeholder : .init())
    }
}

struct BroadcastItemView_Previews: PreviewProvider {
    static var previews: some View {
        BroadcastItemView(broadcast: Broadcast(id: 0, title: "測試公告", author: "作者", url: "https://google.com", dateTime: Date()), isPlaceholder: false)
            .previewLayout(.sizeThatFits)
            .environmentObject(BroadcastViewModel())
    }
}
