//
//  Config.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/25.
//

import Foundation

enum Config {
    static let baseURL: String = {
        guard let path = Bundle.main.infoDictionary!["BASE_URL"] as? String else {
            preconditionFailure("BASE_URL is required in Info.plist")
        }
        return "https://\(path)"
    }()
}
