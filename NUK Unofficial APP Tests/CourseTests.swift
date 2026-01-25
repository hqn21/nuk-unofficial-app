//
//  CourseModelTests.swift
//  NUK_Unofficial_APP_Tests
//
//  Created by Hao-Quan Liu on 2025/7/26.
//

import Testing
import Foundation
@testable import NUK_Unofficial_APP

struct CourseTests {
    @Test func json_decode() async throws {
        // Arrange
        let jsonString = """
        {
            "id": "test_id",
            "program_id": "test_program_id",
            "department_id": "test_department_id",
            "department_id_recommended": "test_department_id_recommended",
            "name": "test_name",
            "course_code": "test_course_code",
            "course_type": "test_course_type",
            "credit": 10,
            "grade": 1,
            "section": null,
            "classroom": "test_classroom",
            "time": "[[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12], [13, 14]]",
            "teacher": "test_teacher",
            "note": "test_note"
        }
        """
        
        // Act
        let data: Data = jsonString.data(using: .utf8)!
        let course: Course = try JSONDecoder().decode(Course.self, from: data)
        
        // Assert
        #expect(course.id == "test_id")
        #expect(course.programId == "test_program_id")
        #expect(course.departmentId == "test_department_id")
        #expect(course.departmentIdRecommended == "test_department_id_recommended")
        #expect(course.name == "test_name")
        #expect(course.courseCode == "test_course_code")
        #expect(course.courseType == "test_course_type")
        #expect(course.credit == 10)
        #expect(course.grade == 1)
        #expect(course.section == nil)
        #expect(course.classroom == "test_classroom")
        #expect(course.time == [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12], [13, 14]])
        #expect(course.teacher == "test_teacher")
        #expect(course.note == "test_note")
        #expect(course.getTimeString() == "一1,2二3,4三Y,5四6,7五8,9六10,11日12,13")
    }
    
    @Test func save_to_keychain() {
        // Arrange
        _ = KeychainManager.shared.delete(key: "test") == true
        #expect(KeychainManager.shared.get(key: "test", type: Course.self) == nil)
        let course: Course = Course(
            id: "test_id",
            programId: "test_program_id",
            departmentId: "test_department_id",
            departmentIdRecommended: "test_department_id_recommended",
            name: "test_name",
            courseCode: "test_course_code",
            courseType: "test_course_type",
            credit: 1,
            grade: 10,
            section: "test_section",
            classroom: "test_classroom",
            time: [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12], [13, 14]],
            teacher: "test_teacher",
            note: "test_note"
        )
        
        // Act
        #expect(KeychainManager.shared.add(key: "test", value: course) == true)
        let courseKeychain: Course = KeychainManager.shared.get(key: "test", type: Course.self)!
        
        // Assert
        #expect(courseKeychain.id == "test_id")
        #expect(courseKeychain.programId == "test_program_id")
        #expect(courseKeychain.departmentId == "test_department_id")
        #expect(courseKeychain.departmentIdRecommended == "test_department_id_recommended")
        #expect(courseKeychain.name == "test_name")
        #expect(courseKeychain.courseCode == "test_course_code")
        #expect(courseKeychain.courseType == "test_course_type")
        #expect(courseKeychain.credit == 1)
        #expect(courseKeychain.grade == 10)
        #expect(courseKeychain.section == "test_section")
        #expect(courseKeychain.classroom == "test_classroom")
        #expect(courseKeychain.time == [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12], [13, 14]])
        #expect(courseKeychain.teacher == "test_teacher")
        #expect(courseKeychain.note == "test_note")
        _ = KeychainManager.shared.delete(key: "test")
    }
}
