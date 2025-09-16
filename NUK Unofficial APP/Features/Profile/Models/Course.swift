//
//  Course.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/1.
//

import Foundation
import SwiftUI

enum CourseCategory: Int {
    case all
    case requiredTogether
    case requiredDepartment
    case electiveMain
    case electiveMainThink
    case electiveMainBeauty
    case electiveMainCitizen
    case electiveMainCulture
    case electiveMainScience
    case electiveMainEthics
    case electiveMainOther
    case electiveSub
    case electiveSubPeople
    case electiveSubScience
    case electiveSubSocial
    case electiveInterest
    case electiveDepartment
    case other
    case null
}

extension CourseCategory {
    func getName() -> String {
        switch self {
        case .all:
            return "學分總計"
        case .requiredTogether:
            return "共同必修"
        case .requiredDepartment:
            return "系訂必修"
        case .electiveMain:
            return "核心通識"
        case .electiveMainThink:
            return "思維方法"
        case .electiveMainBeauty:
            return "美學素養"
        case .electiveMainCitizen:
            return "公民素養"
        case .electiveMainCulture:
            return "文化素養"
        case .electiveMainScience:
            return "科學素養"
        case .electiveMainEthics:
            return "倫理素養"
        case .electiveMainOther:
            return "未分類"
        case .electiveSub:
            return "博雅通識"
        case .electiveSubPeople:
            return "人文科學類"
        case .electiveSubScience:
            return "自然科學類"
        case .electiveSubSocial:
            return "社會科學類"
        case .electiveInterest:
            return "興趣選修"
        case .electiveDepartment:
            return "系訂選修"
        case .other:
            return "未分類"
        case .null:
            return "未知"
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .all:
            return Color("COURSE_GRAY")
        case .requiredDepartment:
            return Color("COURSE_RED")
        case .electiveDepartment:
            return Color("COURSE_ORANGE")
        case .requiredTogether:
            return Color("COURSE_YELLOW")
        case .electiveMain, .electiveMainThink, .electiveMainBeauty, .electiveMainCitizen, .electiveMainCulture, .electiveMainScience, .electiveMainEthics, .electiveMainOther:
            return Color("COURSE_GREEN")
        case .electiveSub, .electiveSubPeople, .electiveSubSocial, .electiveSubScience:
            return Color("COURSE_BLUE")
        case .electiveInterest:
            return Color("COURSE_PURPLE")
        case .other:
            return Color("COURSE_BROWN")
        case .null:
            return Color("TIMETABLE_LITTLE_DARK_GRAY")
        }
    }
    
    func getParent() -> CourseCategory {
        switch self {
        case .electiveMainThink, .electiveMainBeauty, .electiveMainCitizen, .electiveMainCulture, .electiveMainScience, .electiveMainEthics, .electiveMainOther:
            return .electiveMain
        case .electiveSubPeople, .electiveSubSocial, .electiveSubScience:
            return .electiveSub
        default:
            return self
        }
    }
}

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
    
    func getTimeString() -> String {
        if time == nil {
            return "未公佈"
        }
        let days: [String] = ["一", "二", "三", "四", "五", "六", "日"]
        var timeString = ""
        for (idx, periods) in time!.enumerated() {
            if periods.isEmpty {
                continue
            }
            timeString = "\(timeString)\(days[idx])\(periods.map { String($0) }.joined(separator: ","))"
        }
        return timeString
    }
    
    func getCourseCategory() -> CourseCategory {
        switch departmentId {
        case "MI":
            return .other
        case "CD":
            return .other
        case "CHS":
            return .other
        case "CCL":
            return .other
        case "CCM":
            return .other
        case "CCS":
            return .other
        case "CCE":
            return .other
        case "ISP":
            return .other
        case "IFD":
            return .other
        case "NULL":
            return .other
        case "GR":
            return .requiredTogether
        case "CC":
            switch name.prefix(4) {
            case "邏輯思維":
                return .electiveMainThink
            case "哲學基本":
                return .electiveMainThink
            case "藝術概論":
                return .electiveMainBeauty
            case "中國藝術":
                return .electiveMainBeauty
            case "西洋藝術":
                return .electiveMainBeauty
            case "台灣藝術":
                return .electiveMainBeauty
            case "法律與人":
                return .electiveMainCitizen
            case "媒體識讀":
                return .electiveMainCitizen
            case "全球化與":
                return .electiveMainCulture
            case "探索台灣":
                return .electiveMainCulture
            case "科普讀物":
                return .electiveMainScience
            case "科技與社":
                return .electiveMainScience
            case "環境倫理":
                return .electiveMainEthics
            case "企業倫理":
                return .electiveMainEthics
            case "職場倫理":
                return .electiveMainEthics
            case "科技與工":
                return .electiveMainEthics
            default:
                return .electiveMainOther
            }
        case "LI":
            return .electiveSubPeople
        case "SC":
            return .electiveSubScience
        case "SO":
            return .electiveSubSocial
        case "IN":
            return .electiveInterest
        default:
            if courseType == "必" {
                return .requiredDepartment
            } else if courseType == "選" {
                return .electiveDepartment
            } else {
                if name.count > 0 {
                    return .other
                } else {
                    return .null
                }
            }
        }
    }
}
