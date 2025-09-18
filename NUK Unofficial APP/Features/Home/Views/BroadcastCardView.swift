//
//  BroadcastCardView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import SwiftUI

struct BroadcastCardView: View {
    @EnvironmentObject private var viewModel: BroadcastViewModel
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    Text("校園公告")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color("DARK_GRAY"))
                    Spacer()
                    if viewModel.errorMessage != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                            .foregroundColor(Color("YELLOW"))
                            .onTapGesture {
                                showErrorAlert = true
                            }
                    }
                }
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 10) {
                        ForEach(viewModel.broadcasts.isEmpty ? viewModel.fakeBroadcasts : viewModel.broadcasts) { broadcast in
                            BroadcastItemView(broadcast: broadcast, isPlaceholder: viewModel.broadcasts.isEmpty)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .frame(height: 350)
            .padding([.top, .leading, .trailing], 10)
            .alert(
                "校園公告",
                isPresented: $showErrorAlert,
                actions: {
                    Button("確認", action: {})
                },
                message: {
                    Text(viewModel.errorMessage ?? "未知錯誤")
                }
            )
        }
        .task {
            if viewModel.isLoading() {
                await viewModel.getBroadcast()
            }
        }
    }
}

struct BroadcastCardView_Previews: PreviewProvider {
    static var previews: some View {
        BroadcastCardView()
            .previewLayout(.sizeThatFits)
            .environmentObject(BroadcastViewModel())
    }
}
