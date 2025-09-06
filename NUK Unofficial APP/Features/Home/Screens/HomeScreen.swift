//
//  HomeScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var popupManager: PopupManager
    @EnvironmentObject private var youBikeViewModel: YouBikeViewModel
    @StateObject private var weatherViewModel: WeatherViewModel = WeatherViewModel()
    @StateObject private var airViewModel: AirViewModel = AirViewModel()
    @StateObject private var broadcastViewModel: BroadcastViewModel = BroadcastViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("GRAY")
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        HStack(alignment: .top, spacing: 15) {
                            WeatherCardView()
                                .environmentObject(weatherViewModel)
                            AirCardView()
                                .environmentObject(airViewModel)
                        }
                        YouBikeCardView()
                            .environmentObject(youBikeViewModel)
                        BroadcastCardView()
                            .environmentObject(broadcastViewModel)
                    }
                    .padding(15)
                }
                .refreshable {
                    await Task.detached {
                        await weatherViewModel.getWeather()
                        await airViewModel.getAir()
                        await youBikeViewModel.getYouBike()
                        await broadcastViewModel.getBroadcast()
                    }.value
                }
            }
            .navigationTitle("home.title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeScreen()
        .environmentObject(PopupManager())
        .environmentObject(YouBikeViewModel())
}
