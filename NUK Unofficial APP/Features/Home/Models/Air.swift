//
//  Air.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/4.
//

import Foundation

struct Air: Decodable {
    let dateTime: Date
    let aqi: Int
    let pm2_5: Float
    let pm10: Float
    let so2: Float
    let co: Float
    let o3: Float
    let no: Float
    let no2: Float
    let nox: Float
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "date_time"
        case aqi = "aqi"
        case pm2_5 = "pm2_5"
        case pm10 = "pm10"
        case so2 = "so2"
        case co = "co"
        case o3 = "o3"
        case no = "no"
        case no2 = "no2"
        case nox = "nox"
    }
}
