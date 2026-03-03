//
//  SemesterGrade.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2026/2/28.
//

import Foundation

struct SemesterGrade: Codable, Identifiable {
    let id: UUID
    let semester: Semester
    var totalCredit: Double?
    var completedCredit: Double?
    var averageScore: Double?
    var averageGPA: Double?
    var classSize: Int?
    var rank: Int?
    var rankPercentage: Double?
    var grades: [Grade]
}
