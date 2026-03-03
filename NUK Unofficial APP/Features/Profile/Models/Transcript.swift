//
//  Transcript.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2026/3/1.
//

import Foundation

struct Transcript: Codable {
    let semesterGrades: [SemesterGrade]
    var studentId: String?
    var totalCredit: Double?
    var completedCredit: Double?
    var averageScore: Double?
    var averageGPA: Double?
    var rank: Int?
    var rankPercentage: Double?
}
