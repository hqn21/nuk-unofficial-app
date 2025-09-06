//
//  AirViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/4.
//

import Foundation
import Combine
import SwiftUI

class AirViewModel: ObservableObject {
    @Published var air: Air? = nil
    @Published var errorMessage: String? = nil
    
    @MainActor
    func getAir() async -> Void {
        do {
            air = try await APIService.shared.fetch(endpoint: "/air_quality_index")
            errorMessage = nil
        } catch {
            air = nil
            errorMessage = error.localizedDescription
        }
    }
    
    func isLoading() -> Bool {
        return air == nil && errorMessage == nil
    }
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    func getAirIcon(aqi: Int) -> Image {
        var imageName: String = "AIR_6"
        if aqi < 51 {
            imageName = "AIR_1"
        } else if aqi < 101 {
            imageName = "AIR_2"
        } else if aqi < 151 {
            imageName = "AIR_3"
        } else if aqi < 201 {
            imageName = "AIR_4"
        } else if aqi < 301 {
            imageName = "AIR_5"
        }
        return Image("\(imageName)")
    }
}
