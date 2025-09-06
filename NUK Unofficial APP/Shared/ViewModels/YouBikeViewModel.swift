//
//  YouBikeViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import Foundation
import Combine

enum YouBikeAvailableStatus: String {
    case none = "DARK_GRAY"
    case low = "RED"
    case normal = "YELLOW"
    case high = "GREEN"
}

class YouBikeViewModel: ObservableObject {
    @Published var youBikes: [YouBike] = []
    @Published var errorMessage: String? = nil
    let fakeYouBikes: [YouBike] = [
        YouBike(id: 0, name: "測試站點一", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 1, name: "測試站點二", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 2, name: "測試站點三", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 3, name: "測試站點四", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 4, name: "測試站點五", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 5, name: "測試站點六", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 6, name: "測試站點七", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 7, name: "測試站點八", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 8, name: "測試站點九", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
        YouBike(id: 9, name: "測試站點十", parkingSpace: 0, availableSpace: 0, dateTime: Date()),
    ]
    
    @MainActor
    func getYouBike() async -> Void {
        do {
            youBikes = try await APIService.shared.fetch(endpoint: "/youbike")
            youBikes.sort { $0.id < $1.id }
            errorMessage = nil
        } catch {
            youBikes = []
            errorMessage = error.localizedDescription
        }
    }
    
    func isLoading() -> Bool {
        return youBikes.isEmpty && errorMessage == nil
    }
    
    func getAvailableStatus(youBike: YouBike) -> YouBikeAvailableStatus {
        if youBike.parkingSpace == 0 {
            return YouBikeAvailableStatus.none
        }
        let percentage: Float = Float(youBike.availableSpace) / Float(youBike.parkingSpace)
        if percentage < 0.33 {
            return YouBikeAvailableStatus.low
        } else if percentage < 0.66 {
            return YouBikeAvailableStatus.normal
        } else {
            return YouBikeAvailableStatus.high
        }
    }
}
