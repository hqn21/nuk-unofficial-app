//
//  Broadcast.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import Foundation

struct Broadcast: Decodable, Identifiable {
    let id: Int
    let title: String
    let author: String
    let url: String
    let dateTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case author = "author"
        case url = "url"
        case dateTime = "date_time"
    }
}
