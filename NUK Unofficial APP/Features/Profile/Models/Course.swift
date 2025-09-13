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
    
    enum CourseCategory {
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
            switch name[0..<4] {
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
    
    func getCourseCategoryName() -> String {
        let courseCategoryNames: [CourseCategory: String] = [
            .all: "學分總計",
            .requiredDepartment: "系訂必修",
            .electiveDepartment: "系訂選修",
            .requiredTogether: "共同必修",
            .electiveMain: "核心通識",
            .electiveMainThink: "思維方法",
            .electiveMainBeauty: "美學素養",
            .electiveMainCitizen: "公民素養",
            .electiveMainCulture: "文化素養",
            .electiveMainScience: "科學素養",
            .electiveMainEthics: "倫理素養",
            .electiveMainOther: "未分類",
            .electiveSub: "博雅通識",
            .electiveSubPeople: "人文科學類",
            .electiveSubSocial: "社會科學類",
            .electiveSubScience: "自然科學類",
            .electiveInterest: "興趣選修",
            .other: "未分類"
        ]
        return courseCategoryNames[getCourseCategory()] ?? "未知"
    }
}
