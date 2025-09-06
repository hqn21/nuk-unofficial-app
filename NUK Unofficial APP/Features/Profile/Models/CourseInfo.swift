//
//  CourseInfo.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import Foundation

struct CourseInfo: Codable {
    let id: String
    let year: Int
    let semester: Int
    let updatedAt: Date
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case year = "year"
        case semester = "semester"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
