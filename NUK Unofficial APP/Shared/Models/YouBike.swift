//
//  YouBike.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import Foundation

struct YouBike: Decodable, Identifiable {
    let id: Int
    let name: String
    let parkingSpace: Int
    let availableSpace: Int
    let dateTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case parkingSpace = "parking_space"
        case availableSpace = "available_space"
        case dateTime = "date_time"
    }
}
