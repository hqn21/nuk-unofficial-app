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
    @Published var alertConfirmMessage: String? = nil
    @Published var courseSelected: [Course] = []
    @Published var timetable: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
    @Published var courseConfirmed: [Course] = []
    @Published var timetableConfirmed: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
    @Published var timetableType: TimetableType = .normal
    @Published var openCourseSystem: Bool = false
    @Published var transcriptConfirmed: Transcript? = nil
    
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
    func loadTranscriptConfirmed() {
        let transcriptConfirmedFromKeychain: Transcript? = KeychainManager.shared.get(key: "transcript_confirmed", type: Transcript.self)
        if let transcriptConfirmedFromKeychain = transcriptConfirmedFromKeychain {
            transcriptConfirmed = transcriptConfirmedFromKeychain
        } else {
            transcriptConfirmed = nil
        }
    }
    
    @MainActor
    func confirmResetCourseSelected() {
        alertConfirmMessage = "您確定要清除所有所選課程嗎，此動作無法還原，請謹慎操作"
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
    func confirmResetCourseConfirmed() {
        alertConfirmMessage = "您確定要清除所有已匯入的課程嗎，此動作無法還原，請謹慎操作"
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
            .background(Color.white)
            .preferredColorScheme(.light)
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all)
            .snapshot()
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                Task { @MainActor in
                    switch status {
                    case .authorized, .limited:
                        self.alertMessage = "成功將您的課表存入相簿中"
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    default:
                        self.alertMessage = "存入相簿失敗，請至設定確認是否給予權限"
                    }
                }
            }
            
        case .authorized, .limited:
            alertMessage = "成功將您的課表存入相簿中"
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        default:
            alertMessage = "存入相簿失敗，請至設定確認是否給予權限"
        }
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
    
    func getSemesterList(semesterGrades: [SemesterGrade]) -> [Semester] {
        var semesters: [Semester] = []
        for semesterGrade in semesterGrades {
            semesters.append(semesterGrade.semester)
        }
        semesters.sort {
            if $0.year != $1.year { return $0.year > $1.year }
            return $0.term > $1.term
        }
        return semesters
    }
    
    func getSemesterName(semester: Semester) -> String {
        let termName: [Int: String] = [1: "第一學期", 2: "第二學期", 3: "暑修"]
        return "\(semester.year) 學年度\(termName[semester.term] ?? "未知學期")"
    }
    
    func getSemesterGrade(semester: Semester?) -> SemesterGrade? {
        if let transcriptConfirmed = transcriptConfirmed, let semester = semester {
            return transcriptConfirmed.semesterGrades.first {
                $0.semester.year == semester.year && $0.semester.term == semester.term
            }
        } else {
            return nil
        }
    }
    
    func getCompletedCredit(grades: [Grade]) -> Double {
        var completedCredit: Double = 0
        for grade in grades {
            if grade.isPassed() {
                completedCredit += grade.credit
            }
        }
        return completedCredit
    }
    
    func getTotalCredit(grades: [Grade]) -> Double {
        var totalCredit: Double = 0
        for grade in grades {
            totalCredit += grade.credit
        }
        return totalCredit
    }
    
    @MainActor
    func importTimetable() -> String {
        let timetableURLString: String? = KeychainManager.shared.get(key: "action_timetable_url", type: String.self)
        let timetableHTML: String? = KeychainManager.shared.get(key: "action_timetable_html", type: String.self)
        if let timetableURLString = timetableURLString, let timetableURL = URL(string: timetableURLString), let timetableHTML = timetableHTML {
            if let host = timetableURL.host() {
                if host != "course.nuk.edu.tw" {
                    return "這似乎不是國立高雄大學選課系統的頁面，請至快速連結中的選課系統查詢選課結果後再匯入，謝謝"
                }
            } else {
                return "無法辨識此網址，請確認匯入的是國立高雄大學選課系統的選課查詢結果頁面，謝謝"
            }

            if timetableURL.path() != "/Sel/query3.asp" {
                return "這似乎不是「選課查詢結果」頁面，請先完成選課查詢後再匯入，謝謝"
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(timetableHTML)
                let fontList: [Element] = try doc.select("font").array()
                
                if(fontList.count < 1) {
                    return "取得的資訊不包含狀態訊息，請稍後再嘗試並協助問題回報，謝謝"
                }
                
                let alert: String? = try fontList[0].text()
                switch alert {
                case "您的連線已逾時或登錄過程有誤，請重新登錄選課系統！":
                    return "您的帳號或密碼錯誤，請確認後再重新嘗試，謝謝"
                case "資料庫中無您的選課資料！":
                    return "目前學校的資料庫沒有您的選課資料，請確認後再重新嘗試，謝謝"
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
                        return "儲存課程清單時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
                    }
                    if !KeychainManager.shared.addOrUpdate(key: "timetable_confirmed", value: timetable) {
                        return "儲存課表資訊時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
                    }
                    loadCourseConfirmed()
                    return "成功匯入 \(courses.count) 門課！"
                }
            } catch {
                return "解析課表資訊時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
            }
        } else {
            return "匯入課表失敗，請稍後再試並協助問題回報"
        }
    }
    
    @MainActor
    func importScore() -> String {
        let scoreURLString: String? = KeychainManager.shared.get(key: "action_score_url", type: String.self)
        let scoreHTML: String? = KeychainManager.shared.get(key: "action_score_html", type: String.self)
        if let scoreURLString = scoreURLString, let scoreURL = URL(string: scoreURLString), let scoreHTML = scoreHTML {
            if let host = scoreURL.host() {
                if host != "aca.nuk.edu.tw" {
                    return "這似乎不是國立高雄大學教務系統的頁面，請至快速連結中的教務系統查詢成績後再匯入，謝謝"
                }
            } else {
                return "無法辨識此網址，請確認匯入的是國立高雄大學教務系統的成績查詢結果頁面，謝謝"
            }

            if scoreURL.path() != "/Student2/SO/ScoreQuery.asp" {
                return "這似乎不是「成績查詢結果」頁面，請先完成成績查詢後再匯入，謝謝"
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(scoreHTML)
                let fontList: [Element] = try doc.select("font").array()
                
                if(fontList.count < 1) {
                    return "取得的資訊不包含狀態訊息，請稍後再嘗試並協助問題回報，謝謝"
                }
                
                let alert: String? = try fontList[0].text()
                switch alert {
                case "您的連線已逾時，請重新登錄後再執行本系統！":
                    return "您的帳號或密碼錯誤，請確認後再重新嘗試，謝謝"
                case "目前無您所選擇學年、學期的選課資料，請確認。如有問題請洽教務處！":
                    return "找不到您在該學年度的學期成績，請確認後再重新嘗試，謝謝"
                default:
                    var semesterGrades: [SemesterGrade] = []
                    let semesterHeaders: [Element] = try doc.select("font[color=#0000FF] > b").array()
                    let courseTables: [Element] = try doc.select("table[border=1]").array()
                    let summaryTables: [Element] = try doc.select("table[border=0][style*=color: #800000]:not(:contains(學習成效期中預警))").array()
                    let cumulativeSummaryTable: Element? = try doc.select("table[border=0][style*=color: #800080][cellpadding=3]").array().first
                    let profileTable: Element? = try doc.select("table[border=0][style*=color: #800080][cellpadding=2]").array().first
                    for (index, header) in semesterHeaders.enumerated() {
                        let numbers = try header.text().matches(of: /\d+/).map { Int($0.output) }
                        if numbers.count != 2 {
                            continue
                        }
                        let semester: Semester = Semester(id: UUID(), year: numbers[0]!, term: numbers[1]!)
                        var semesterGrade: SemesterGrade = SemesterGrade(id: UUID(), semester: semester, totalCredit: 0, completedCredit: 0, grades: [])
                        // Course
                        let courseTable: Element = courseTables[index]
                        let courseRows: Elements = try courseTable.select("tr")
                        for i in 1..<courseRows.count {
                            let cells: Elements = try courseRows.get(i).select("td")
                            let rawId: String = try cells.get(0).text().trimmingCharacters(in: .whitespaces)
                            let splitIndex = rawId.index(rawId.endIndex, offsetBy: -4)
                            let departmentId = String(rawId[..<splitIndex])
                            let courseCode: String = String(rawId[splitIndex...])
                            let name: String = try cells.get(1).text().trimmingCharacters(in: .whitespaces)
                            let credit: Double = try Double(cells.get(2).text().trimmingCharacters(in: .whitespaces)) ?? 0
                            let courseType: String = try cells.get(3).text().trimmingCharacters(in: .whitespaces) == "必修" ? "必" : "選"
                            let midtermScore: Int? = try Int(cells.get(4).text().trimmingCharacters(in: .whitespaces))
                            let finalScore: Int? = try Int(cells.get(5).text().trimmingCharacters(in: .whitespaces))
                            let grade: Grade = Grade(id: UUID(), departmentId: departmentId, name: name, courseCode: courseCode, courseType: courseType, credit: credit, midtermScore: midtermScore, finalScore: finalScore)
                            semesterGrade.grades.append(grade)
                        }
                        // Summary
                        let summaryTable: Element = summaryTables[index]
                        let cells: Elements = try summaryTable.select("td")
                        semesterGrade.totalCredit = try cells.get(0).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        semesterGrade.completedCredit = try cells.get(1).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        semesterGrade.averageScore = try cells.get(2).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        semesterGrade.averageGPA = try cells.get(3).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        semesterGrade.classSize = try cells.get(5).text().matches(of: /：([\d.]+)/).first.map { Int($0.1)! }
                        semesterGrade.rank = try cells.get(4).text().matches(of: /：([\d.]+)/).first.map { Int($0.1)! }
                        semesterGrade.rankPercentage = try cells.get(6).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        semesterGrades.append(semesterGrade)
                    }
                    var transcript: Transcript = Transcript(semesterGrades: semesterGrades)
                    if let cumulativeSummaryTable = cumulativeSummaryTable {
                        let cells: Elements = try cumulativeSummaryTable.select("td")
                        transcript.totalCredit = try cells.get(1).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        transcript.completedCredit = try cells.get(2).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        transcript.averageScore = try cells.get(3).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        transcript.averageGPA = try cells.get(4).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                        transcript.rank = try cells.get(5).text().matches(of: /：([\d.]+)/).first.map { Int($0.1)! }
                        transcript.rankPercentage = try cells.get(6).text().matches(of: /：([\d.]+)/).first.map { Double($0.1)! }
                    }
                    if let profileTable = profileTable {
                        let cells: Elements = try profileTable.select("td")
                        transcript.studentId = try cells.get(2).text().matches(of: /：([A-Za-z0-9]+)/).first.map { String($0.1) }
                    }
                    if !KeychainManager.shared.addOrUpdate(key: "transcript_confirmed", value: transcript) {
                        return "儲存成績單時發生了錯誤，請稍後再嘗試並協助問題回報，謝謝"
                    }
                    loadTranscriptConfirmed()
                    return "成功匯入 \(transcript.semesterGrades.count) 個學期的成績！"
                }
            } catch {
                return "解析成績資訊時發生了錯誤，請稍候再嘗試並協助問題回報，謝謝"
            }
        } else {
            return "匯入成績失敗，請稍後再試並協助問題回報"
        }
    }
}
