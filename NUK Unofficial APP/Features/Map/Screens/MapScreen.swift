//
//  MapScreen.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @EnvironmentObject private var youBikeViewModel: YouBikeViewModel
    @StateObject private var viewModel: MapViewModel = MapViewModel()
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.annotationItems) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        AnnotationItemView(annotationItem: item)
                            .environmentObject(viewModel)
                    }
                }
                    .accentColor(Color.blue)
                    .alert(
                        "地圖",
                        isPresented: $showErrorAlert,
                        actions: {
                            Button("確認", action: {})
                        },
                        message: {
                            Text(viewModel.errorMessage ?? "未知錯誤")
                        }
                    )
                    .sheet(isPresented: $viewModel.showSheet, onDismiss: {
                        viewModel.resetFocus()
                    }) {
                        Group {
                            if let annotationItem = viewModel.focusAnnotationItem {
                                MapSheetView(annotationItem: annotationItem)
                            }
                        }
                        .presentationDetents([.fraction(0.35), .medium])
                        .presentationBackgroundInteraction(
                            .enabled(upThrough: .fraction(0.35))
                        )
                    }
                    .onAppear() {
                        viewModel.initLocationManager()
                    }
                VStack(spacing: 0) {
                    Button(action: {
                        viewModel.resetMapCenter()
                    },label: {
                        Image(systemName: "graduationcap.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(13)
                    })
                    Divider()
                        .frame(width: 46)
                    Button(action: {
                        if(!viewModel.setUserLocationAsMapCenter()) {
                            showErrorAlert = true
                        }
                    },label: {
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(13)
                    })
                }
                .background(Color("WHITE").opacity(0.9))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(15)
            }
            .navigationTitle("地圖")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                viewModel.setYouBikeDescription(youBikes: youBikeViewModel.youBikes)
            }
        }
    }
}

#Preview {
    MapScreen()
        .environmentObject(YouBikeViewModel())
}
