//
//  Course.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import Foundation

struct Course: Codable, Identifiable {
    let id: String
    let programId: String
    let departmentId: String
    let departmentIdRecommended: String
    let name: String
    let courseCode: String
    let courseType: String
    let credit: Double
    let grade: Int
    let section: String?
    let classroom: String?
    let time: [[Int]]?
    let teacher: String?
    let note: String?
    
    init(id: String,
        programId: String,
        departmentId: String,
        departmentIdRecommended: String,
        name: String,
        courseCode: String,
        courseType: String,
        credit: Double,
        grade: Int,
        section: String? = nil,
        classroom: String? = nil,
        time: [[Int]]? = nil,
        teacher: String? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.programId = programId
        self.departmentId = departmentId
        self.departmentIdRecommended = departmentIdRecommended
        self.name = name
        self.courseCode = courseCode
        self.courseType = courseType
        self.credit = credit
        self.grade = grade
        self.section = section
        self.classroom = classroom
        self.time = time
        self.teacher = teacher
        self.note = note
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case programId = "program_id"
        case departmentId = "department_id"
        case departmentIdRecommended = "department_id_recommended"
        case name = "name"
        case courseCode = "course_code"
        case courseType = "course_type"
        case credit = "credit"
        case grade = "grade"
        case section = "section"
        case classroom = "classroom"
        case time = "time"
        case teacher = "teacher"
        case note = "note"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        programId = try container.decode(String.self, forKey: .programId)
        departmentId = try container.decode(String.self, forKey: .departmentId)
        departmentIdRecommended = try container.decode(String.self, forKey: .departmentIdRecommended)
        name = try container.decode(String.self, forKey: .name)
        courseCode = try container.decode(String.self, forKey: .courseCode)
        courseType = try container.decode(String.self, forKey: .courseType)
        credit = try container.decode(Double.self, forKey: .credit)
        grade = try container.decode(Int.self, forKey: .grade)
        section = try container.decodeIfPresent(String.self, forKey: .section)
        classroom = try container.decodeIfPresent(String.self, forKey: .classroom)
        teacher = try container.decodeIfPresent(String.self, forKey: .teacher)
        note = try container.decodeIfPresent(String.self, forKey: .note)
        // decode from json string
        if let timeString = try? container.decode(String.self, forKey: .time),
            let timeData = timeString.data(using: .utf8),
            let decodedTime = try? JSONDecoder().decode([[Int]].self, from: timeData) {
                time = decodedTime
        // decode from [[Int]]
        } else if let timeArray = try? container.decodeIfPresent([[Int]].self, forKey: .time) {
            time = timeArray
        } else {
            time = nil
        }
    }
}
