//
//  YouBikeCardView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import SwiftUI

struct YouBikeCardView: View {
    @EnvironmentObject private var viewModel: YouBikeViewModel
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    Text("common.youbike.title")
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
                HStack(spacing: 10) {
                    VStack(spacing: 10) {
                        ForEach(
                            Array(viewModel.youBikes.isEmpty ? viewModel.fakeYouBikes.enumerated() : viewModel.youBikes.enumerated())
                                .filter { $0.offset % 2 == 0 }
                                .map { $0.element }
                        ) { youBike in
                            YouBikeStationView(youBike: youBike)
                        }
                    }
                    VStack(spacing: 10) {
                        ForEach(
                            Array(viewModel.youBikes.isEmpty ? viewModel.fakeYouBikes.enumerated() : viewModel.youBikes.enumerated())
                                .filter { $0.offset % 2 == 1 }
                                .map { $0.element }
                        ) { youBike in
                            YouBikeStationView(youBike: youBike)
                        }
                    }
                }
                .redacted(reason: viewModel.youBikes.isEmpty ? .placeholder : .init())
            }
            .padding(10)
            .alert(
                "common.youbike.title",
                isPresented: $showErrorAlert,
                actions: {
                    Button("common.general.confirm", action: {})
                },
                message: {
                    Text(verbatim: "\(viewModel.errorMessage ?? String(localized: "common.error.unknown"))")
                }
            )
        }
        .task {
            if viewModel.isLoading() {
                await viewModel.getYouBike()
            }
        }
    }
}

struct YouBikeCardView_Previews: PreviewProvider {
    static var previews: some View {
        YouBikeCardView()
            .previewLayout(.sizeThatFits)
            .environmentObject(YouBikeViewModel())
    }
}
