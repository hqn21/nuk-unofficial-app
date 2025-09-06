//
//  AirCardView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/4.
//

import SwiftUI

struct AirCardView: View {
    @EnvironmentObject private var popupManager: PopupManager
    @EnvironmentObject private var viewModel: AirViewModel
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            VStack(spacing: 10) {
                Text("home.air.title")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Group {
                    if(viewModel.isLoading()) {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("DARK_GRAY"))
                            .redacted(reason: .placeholder)
                    } else if viewModel.errorMessage != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("YELLOW"))
                    } else if let air = viewModel.air  {
                        viewModel.getAirIcon(aqi: air.aqi)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(height: 64)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(10)
            .alert(
                "home.air.title.long",
                isPresented: $showErrorAlert,
                actions: {
                    Button("common.general.confirm", action: {})
                },
                message: {
                    Text(verbatim: "\(viewModel.errorMessage ?? String(localized: "common.error.unknown"))")
                }
            )
            .onTapGesture {
                if viewModel.errorMessage != nil {
                    showErrorAlert = true
                } else if viewModel.air != nil {
                    popupManager.set(popup: AnyView(
                        AirPopupView()
                            .environmentObject(viewModel)
                    ))
                }
            }
        }
        .task {
            if viewModel.isLoading() {
                await viewModel.getAir()
            }
        }
    }
}

struct AirCardView_Previews: PreviewProvider {
    static var previews: some View {
        AirCardView()
            .previewLayout(.sizeThatFits)
            .environmentObject(PopupManager())
            .environmentObject(AirViewModel())
    }
}
