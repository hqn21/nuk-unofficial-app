//
//  WeatherCard.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI

struct WeatherCardView: View {
    @EnvironmentObject private var popupManager: PopupManager
    @EnvironmentObject private var viewModel: WeatherViewModel
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("WHITE"))
                .shadow(color: Color("SHADOW"), radius: 2, x: 0, y: 1)
            VStack(spacing: 10) {
                Text("天氣")
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
                    } else {
                        viewModel.getWeatherIcon(dateTime: viewModel.weathers[0].dateTime, weather: viewModel.weathers[0].weather)
                    }
                }
                .frame(height: 64)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(10)
            .alert(
                "天氣預報",
                isPresented: $showErrorAlert,
                actions: {
                    Button("確認", action: {})
                },
                message: {
                    Text(viewModel.errorMessage ?? "未知錯誤")
                }
            )
            .onTapGesture {
                if viewModel.errorMessage != nil {
                    showErrorAlert = true
                } else if !viewModel.weathers.isEmpty {
                    popupManager.set(popup: AnyView(
                        WeatherPopupView()
                            .environmentObject(viewModel)
                    ))
                }
            }
        }
        .task {
            if viewModel.isLoading() {
                await viewModel.getWeather()
            }
        }
    }
}

struct WeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCardView()
            .previewLayout(.sizeThatFits)
            .environmentObject(PopupManager())
            .environmentObject(WeatherViewModel())
    }
}
