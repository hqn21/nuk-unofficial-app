//
//  AnnotationItem.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/7.
//

import Foundation
import MapKit

enum AnnotationCategory: String {
    case youBike = "UBIKE"
    case building = "BUILDING"
    case dorm = "ROOM"
    
    var fullName: String {
        switch self {
        case .youBike:
            return String(localized: "common.youbike.title")
        case .building:
            return String(localized: "map.building.title")
        case .dorm:
            return String(localized: "map.dorm.title")
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
