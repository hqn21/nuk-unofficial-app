//
//  CourseEnrollment.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import Foundation

struct CourseEnrollment: Decodable {
    let id: String
    let enrollment: Int?
    let enrollmentPending: Int?
    let enrollmentLimit: Int?
    let enrollmentAvailable: Int?
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case enrollment = "enrollment"
        case enrollmentPending = "enrollment_pending"
        case enrollmentLimit = "enrollment_limit"
        case enrollmentAvailable = "enrollment_available"
        case updatedAt = "updated_at"
    }
}
