//
//  WeatherPopupView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/31.
//

import SwiftUI

struct WeatherPopupView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text("天氣預報")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("DARK_GRAY"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.weathers) { weather in
                        VStack(spacing: 10) {
                            HStack(spacing: 0) {
                                Text(verbatim: "\(viewModel.getHourString(date: weather.dateTime))")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(Color("DARK_GRAY"))
                                    .padding(5)
                                Divider()
                                    .frame(height: 18)
                                Text(verbatim: "\(weather.rainProbability)%")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(Color("DARK_GRAY"))
                                    .padding(5)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                            viewModel.getWeatherIcon(dateTime: weather.dateTime, weather: weather.weather)
                                .frame(height: 32)
                            Text(verbatim: "\(weather.temperature)°C")
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
            }
        }
        .padding([.top, .bottom], 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("WHITE"))
        )
        .padding(15)
    }
}

struct WeatherPopupView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherPopupView()
            .previewLayout(.sizeThatFits)
            .environmentObject(WeatherViewModel())
    }
}
