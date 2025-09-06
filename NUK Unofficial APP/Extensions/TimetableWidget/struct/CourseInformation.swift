//
//  CourseInformation.swift
//  TimetableExtension
//
//  Created by Haoquan Liu on 2022/10/4.
//

import Foundation

struct CourseInformation: Hashable, Codable, Identifiable {
    // 必要資訊
    let id: String // 系所代碼 + 課程代碼
    let departmentId: String // 系所代碼
    let departmentName: String // 系所名稱
    let courseId: String // 課程代碼
    let courseName: String // 課程名稱
    let courseRoom: String // 課程教室
    let courseTime: String // 課程上課時間
    let courseTimeArray: [[Int]] // 課程上課時間陣列
    let courseKind: String // 課程種類
    let category: String // 必修或選修
    let credit: Float // 學分數
    let teacher: String // 上課老師
    let website: String // 課程連結網站
    // 次要資訊（選課結果沒有的資訊）
    let grade: Int? // 年級
    let courseClass: String? // 班別
    let rule: String?
    let notice: String?
    // 次次要資訊（除了選課結果以外都沒有的資訊）
    let selectedTime: String? // 哪時候選到這堂課的
}
