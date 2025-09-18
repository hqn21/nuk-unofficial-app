//
//  AnnotationItem.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/7.
//

import Foundation
import MapKit

enum AnnotationCategory: String {
    case youBike = "BikeStationPin"
    case building = "BuildingPin"
    case dorm = "DormPin"
    
    var fullName: String {
        switch self {
        case .youBike:
            return "YouBike 站點"
        case .building:
            return "重要建築"
        case .dorm:
            return "宿舍"
        }
    }
    
    var iconName: String {
        switch self {
        case .youBike:
            return "bicycle.circle"
        case .building:
            return "building"
        case .dorm:
            return "dorm"
        }
    }
}

struct AnnotationItem: Identifiable {
    let id: UUID = UUID()
    let name: String
    let category: AnnotationCategory
    var description: String
    let coordinate: CLLocationCoordinate2D
}
