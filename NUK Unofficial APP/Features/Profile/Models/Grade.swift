//
//  Grade.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2026/2/27.
//

import Foundation
import SwiftUI

struct Grade: Codable, Identifiable, CreditCategorizable {
    let id: UUID
    let departmentId: String
    let name: String
    let courseCode: String
    let courseType: String
    let credit: Double
    let midterm: Int?
    let final: Int?
    var countableCredit: Double { isPassed() ? credit : 0 }
    
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
    
    func isPassed() -> Bool {
        if let final = final {
            if final >= 60 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getColor() -> Color {
        if let final = final {
            if final >= 60 {
                return Color("GREEN")
            } else {
                return Color("RED")
            }
        } else {
            return Color("LITTLE_DARK_GRAY")
        }
    }
}
