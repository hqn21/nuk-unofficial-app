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

class CourseViewModel: ObservableObject {
    @Published var hasUpdate: Bool = false
    @Published var courseInfo: CourseInfo? = nil
    @Published var course: [Course] = []
    @Published var department: [Department] = []
    @Published var program: [Program] = []
    @Published var courseEnrollment: CourseEnrollment? = nil
    @Published var courseEnrollmentError: Error? = nil
    @Published var showAlert: Bool = false
    @Published var alertMessage: String? = nil {
        didSet {
            if alertMessage != nil {
                showAlert = true
            }
        }
    }
    @Published var courseSelected: [Course] = []
    @Published var timetable: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
    
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
    func selectCourse(course: Course) -> Void {
        courseSelected.append(course)
        if let time = course.time {
            for (day, periods) in time.enumerated() {
                for period in periods {
                    timetable[day][period] = course
                }
            }
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
}
