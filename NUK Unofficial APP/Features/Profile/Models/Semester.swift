//
//  Semester.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2026/3/2.
//

import Foundation

struct Semester: Codable, Identifiable {
    let id: UUID
    let year: Int
    let term: Int
}
