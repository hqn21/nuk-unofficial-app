//
//  CourseViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/3/6.
//

import Foundation
import Combine
import OSLog
import SwiftUI
import UIKit
import Photos
import SwiftSoup

class CourseViewModel: ObservableObject {
    @Published var hasUpdate: Bool = false
    @Published var courseInfo: CourseInfo? = nil
    @Published var course: [Course] = []
    @Published var department: [Department] = []
    @Published var program: [Program] = []
    @Published var courseEnrollment: CourseEnrollment? = nil
    @Published var courseEnrollmentError: Error? = nil
    @Published var alertMessage: String? = nil
    @Published var courseSelected: [Course] = []
    @Published var timetable: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
    @Published var courseConfirmed: [Course] = []
    @Published var timetableConfirmed: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
    @Published var timetableType: TimetableType = .normal
    
    @MainActor
    func checkUpdate() async -> Bool {
        let courseInfoFromKeychain: CourseInfo? = KeychainManager.shared.get(key: "course_info", type: CourseInfo.self)
        let courseFromKeychain: [Course]? = KeychainManager.shared.get(key: "course", type: [Course].self)
        if let courseInfoFromKeychain = courseInfoFromKeychain, let _ = courseFromKeychain {
            do {
                let courseInfoFromAPI: CourseInfo = try await APIService.shared.fetch(endpoint: "/course_info")
                if courseInfoFromKeychain.id != courseInfoFromAPI.id {
                    hasUpdate = true
                } else {
                    hasUpdate = false
                }
            } catch {
                hasUpdate = false
                alertMessage = error.localizedDescription
            }
        } else {
            hasUpdate = true
        }
        return hasUpdate
    }
    
    @MainActor
    func getCourse() async -> Void {
        if await checkUpdate() == false {
            courseInfo = KeychainManager.shared.get(key: "course_info", type: CourseInfo.self)!
            course = KeychainManager.shared.get(key: "course", type: [Course].self)!
            alertMessage = alertMessage ?? "您的課程資訊已是最新版本"
            return
        }
        do {
            let courseInfoFromAPI: CourseInfo = try await APIService.shared.fetch(endpoint: "/course_info")
            let courseFromAPI: [Course] = try await APIService.shared.fetch(endpoint: "/course")
            if !KeychainManager.shared.addOrUpdate(key: "course_info", value: courseInfoFromAPI) || !KeychainManager.shared.addOrUpdate(key: "course", value: courseFromAPI) {
                alertMessage = "更新課程資料時發生了錯誤"
                return
            }
            courseInfo = courseInfoFromAPI
            course = courseFromAPI
            await _ = checkUpdate()
            alertMessage = "您的課程資訊已成功更新"
        } catch {
            alertMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getCourseIfNeeded() async -> Void {
        let courseInfoFromKeychain: CourseInfo? = KeychainManager.shared.get(key: "course_info", type: CourseInfo.self)
        let courseFromKeychain: [Course]? = KeychainManager.shared.get(key: "course", type: [Course].self)
        
        if let courseInfoFromKeychain = courseInfoFromKeychain, let courseFromKeychain = courseFromKeychain {
            courseInfo = courseInfoFromKeychain
            course = courseFromKeychain
            await _ = checkUpdate()
            return
        }
        await getCourse()
    }
    
    @MainActor
    func getDepartment() async -> Void {
        do {
            let departmentFromAPI: [Department] = try await APIService.shared.fetch(endpoint: "/department")
            if !KeychainManager.shared.addOrUpdate(key: "department", value: departmentFromAPI) {
                alertMessage = "獲取系所列表時發生了錯誤"
                return
            }
            department = departmentFromAPI
        } catch {
            alertMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getDepartmentIfNeeded() async -> Void {
        let departmentFromKeychain: [Department]? = KeychainManager.shared.get(key: "department", type: [Department].self)
        if let departmentFromKeychain = departmentFromKeychain {
            department = departmentFromKeychain
            return
        }
        await getDepartment()
    }
    
    @MainActor
    func getDepartmentName(id: String) -> String? {
        return department.first(where: { $0.id == id })?.name
    }
    
    @MainActor
    func getProgram() async -> Void {
        do {
            let programFromAPI: [Program] = try await APIService.shared.fetch(endpoint: "/program")
            if !KeychainManager.shared.addOrUpdate(key: "program", value: programFromAPI) {
                alertMessage = "獲取部別列表時發生了錯誤"
                return
            }
            program = programFromAPI
        } catch {
            alertMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getProgramIfNeeded() async -> Void {
        let programFromKeychain: [Program]? = KeychainManager.shared.get(key: "program", type: [Program].self)
        if let programFromKeychain = programFromKeychain {
            program = programFromKeychain
            return
        }
        await getProgram()
    }
    
    @MainActor
    func getProgramName(id: String) -> String? {
        return program.first(where: { $0.id == id })?.name
    }
    
    @MainActor
    func getCourseEnrollment(id: String) async -> Void {
        courseEnrollment = nil
        courseEnrollmentError = nil
        do {
            courseEnrollment = try await APIService.shared.fetch(endpoint: "/course_enrollment/\(id)")
            courseEnrollmentError = nil
        } catch {
            courseEnrollment = nil
            courseEnrollmentError = error
        }
    }
    
    @MainActor
    func getCourseEnrollmentStatusMessage() -> String {
        if let courseEnrollment = courseEnrollment {
            return "成功獲取課程狀態資訊，資料最後更新時間為 \(getDateString(date: courseEnrollment.updatedAt))"
        } else if let courseEnrollmentError = courseEnrollmentError {
            return courseEnrollmentError.localizedDescription
        }
        return "正在取得課程即時人數資訊中"
    }
    
    @MainActor
    func getCourseEnrollmentStatusIconName() -> String {
        if courseEnrollment != nil {
            return "checkmark.circle.fill"
        } else if courseEnrollmentError != nil {
            return "xmark.circle.fill"
        }
        return "info.circle.fill"
    }
    
    @MainActor
    func getCourseEnrollmentStatusColor() -> Color {
        if courseEnrollment != nil {
            return Color("GREEN")
        } else if courseEnrollmentError != nil {
            return Color("RED")
        }
        return Color("YELLOW")
    }
    
    @MainActor
    func loadCourseSelected() {
        let courseSelectedFromKeychain: [Course]? = KeychainManager.shared.get(key: "course_selected", type: [Course].self)
        let timetableFromKeychain: [[Course?]]? = KeychainManager.shared.get(key: "timetable_draft", type: [[Course?]].self)
        if let courseSelectedFromKeychain = courseSelectedFromKeychain, let timetableFromKeychain = timetableFromKeychain {
            courseSelected = courseSelectedFromKeychain
            timetable = timetableFromKeychain
        } else {
            courseSelected = []
            timetable = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
        }
    }
    
    @MainActor
    func loadCourseConfirmed() {
        let courseConfirmedFromKeychain: [Course]? = KeychainManager.shared.get(key: "course_confirmed", type: [Course].self)
        let timetableConfirmedFromKeychain: [[Course?]]? = KeychainManager.shared.get(key: "timetable_confirmed", type: [[Course?]].self)
        if let courseConfirmedFromKeychain = courseConfirmedFromKeychain, let timetableConfirmedFromKeychain = timetableConfirmedFromKeychain {
            courseConfirmed = courseConfirmedFromKeychain
            timetableConfirmed = timetableConfirmedFromKeychain
        } else {
            courseConfirmed = []
            timetableConfirmed = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
        }
    }
    
    @MainActor
    func loadCourse() {
        let courseFromKeychain: [Course]? = KeychainManager.shared.get(key: "course", type: [Course].self)
        if let courseFromKeychain = courseFromKeychain {
            course = courseFromKeychain
        } else {
            course = []
        }
    }
    
    @MainActor
    func resetCourseSelected() {
        if !KeychainManager.shared.delete(key: "course_selected") || !KeychainManager.shared.delete(key: "timetable_draft") {
            alertMessage = "清除勾選課程資訊時發生了錯誤"
            return
        }
        loadCourseSelected()
        alertMessage = "成功清除所有所選課程"
    }
    
    @MainActor
    func resetCourseConfirmed() {
        if !KeychainManager.shared.delete(key: "course_confirmed") || !KeychainManager.shared.delete(key: "timetable_confirmed") {
            alertMessage = "清除已匯入的課程資訊時發生了錯誤"
            return
        }
        loadCourseConfirmed()
        alertMessage = "成功清除所有已匯入的課程資訊"
    }
    
    @MainActor
    func selectCourse(course: Course) -> Void {
        courseSelected.append(course)
        if let time = course.time {
            for (day, periods) in time.enumerated() {
                for period in periods {
                    timetable[day][period] = course
                }
            }
        }
        if !KeychainManager.shared.addOrUpdate(key: "course_selected", value: courseSelected) || !KeychainManager.shared.addOrUpdate(key: "timetable_draft", value: timetable) {
            alertMessage = "儲存勾選課程資訊時發生了錯誤"
            return
        }
    }
    
    @MainActor
    func unselectCourse(course: Course) -> Void {
        courseSelected.removeAll(where: { $0.id == course.id })
        if let time = course.time {
            for (day, periods) in time.enumerated() {
                for period in periods {
                    timetable[day][period] = nil
                }
            }
        }
        if !KeychainManager.shared.addOrUpdate(key: "course_selected", value: courseSelected) || !KeychainManager.shared.addOrUpdate(key: "timetable_draft", value: timetable) {
            alertMessage = "儲存勾選課程資訊時發生了錯誤"
            return
        }
    }
    
    func getCourseWebsite(course: Course) -> String {
        if courseInfo == nil {
            return "https://course.nuk.edu.tw/QueryCourse/tcontent.asp?OpenYear=114&Helf=1&Sclass=\(course.departmentId)&Cono=\(course.courseCode)"
        }
        return "https://course.nuk.edu.tw/QueryCourse/tcontent.asp?OpenYear=\(courseInfo!.year)&Helf=\(courseInfo!.semester)&Sclass=\(course.departmentId)&Cono=\(course.courseCode)"
    }
    
    func isSelected(course: Course) -> Bool {
        if courseSelected.contains(where: { $0.id == course.id }) {
            return true
        }
        return false
    }
    
    func canClick(course: Course) -> Bool {
        if isSelected(course: course) {
            return true
        }
        if let time = course.time {
            for (day, periods) in time.enumerated() {
                for period in periods {
                    if timetable[day][period] != nil {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    @MainActor
    func saveTimetable(timetableType: TimetableType, timetable: [[Course?]]) -> Void {
        let image: UIImage = TimetableView(timetableType: timetableType, timetable: timetable)
            .preferredColorScheme(.light)
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all)
            .snapshot()
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) {
                status in
                switch status {
                case .authorized:
                    self.alertMessage = "成功將您的課表存入相簿中"
                default:
                    self.alertMessage = "存入相簿失敗，請至設定確認是否給予權限"
                }
            }
            
        case .authorized:
            alertMessage = "成功將您的課表存入相簿中"
        default:
            alertMessage = "存入相簿失敗，請至設定確認是否給予權限"
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func loadTimetableType() {
        let timetableTypeFromKeychain: TimetableType? = KeychainManager.shared.get(key: "timetable_draft_type", type: TimetableType.self)
        if let timetableTypeFromKeychain = timetableTypeFromKeychain {
            timetableType = timetableTypeFromKeychain
        } else {
            timetableType = .normal
        }
    }
    
    @MainActor
    func setTimetableType(timetableType: TimetableType) {
        self.timetableType = timetableType
        if !KeychainManager.shared.addOrUpdate(key: "timetable_draft_type", value: self.timetableType) {
            alertMessage = "儲存課表類型失敗"
            return
        }
    }
    
    func getCoursesByRawIds(rawIds: [String]) -> [Course] {
        var rawIds: [String] = rawIds
        var courses: [Course] = []
        for singleCourse in course {
            let singleCourseRawId: String = "\(singleCourse.departmentId)\(singleCourse.courseCode)"
            for rawId in rawIds {
                if rawId == singleCourseRawId {
                    courses.append(singleCourse)
                    rawIds.remove(at: rawIds.firstIndex(of: rawId)!)
                    break
                }
            }
        }
        return courses
    }
    
    @MainActor
    func importTimetable() {
        let timetableURL: String? = KeychainManager.shared.get(key: "action_timetable_url", type: String.self)
        let timetableHTML: String? = KeychainManager.shared.get(key: "action_timetable_html", type: String.self)
        if let _ = timetableURL, let timetableHTML = timetableHTML {
            do {
                let doc: Document = try SwiftSoup.parse(timetableHTML)
                let fontList: [Element] = try doc.select("font").array()
                
                if(fontList.count < 1) {
                    alertMessage = "取得的資訊不包含狀態訊息，請稍後再嘗試並協助問題回報，謝謝"
                    return
                }
                
                let alert: String? = try fontList[0].text()
                switch alert {
                case "您的連線已逾時或登錄過程有誤，請重新登錄選課系統！":
                    alertMessage = "您的帳號或密碼錯誤，請確認後再重新嘗試，謝謝"
                case "資料庫中無您的選課資料！":
                    alertMessage = "目前學校的資料庫沒有您的選課資料，請確認後再重新嘗試，謝謝"
                default:
                    var rawIds: [String] = []
                    let trList: [Element] = try doc.select("tr").array()
                    var trIndex: Int = 0
                    for tr in trList {
                        if trIndex != 0 {
                            var trHTML: String = try tr.html()
                            trHTML = "<table>\(trHTML)</table>"
                            let trDoc: Document = try SwiftSoup.parse(trHTML)
                            let tdList: [Element] = try trDoc.select("td").array()
                            if tdList.count != 10 {
                                continue
                            }
                            rawIds.append(try tdList[1].text())
                        }
                        trIndex = trIndex + 1
                    }
                    let courses: [Course] = getCoursesByRawIds(rawIds: rawIds)
                    var timetable: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
                    for course in courses {
                        if let time = course.time {
                            for (day, periods) in time.enumerated() {
                                for period in periods {
                                    timetable[day][period] = course
                                }
                            }
                        }
                    }
                    if !KeychainManager.shared.addOrUpdate(key: "course_confirmed", value: courses) {
                        alertMessage = "儲存課程清單時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
                        return
                    }
                    if !KeychainManager.shared.addOrUpdate(key: "timetable_confirmed", value: timetable) {
                        alertMessage = "儲存課表資訊時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
                        return
                    }
                    loadCourseConfirmed()
                    alertMessage = "成功匯入 \(courses.count) 門課！"
                }
            } catch {
                alertMessage = "解析課表資訊時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
            }
        } else {
            alertMessage = "匯入課表失敗，請稍後再試並協助問題回報"
        }
    }
}
