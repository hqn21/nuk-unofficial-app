//
//  Weather.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/23.
//

import Foundation

struct Weather: Decodable, Identifiable {
    let id: UUID = UUID()
    let dateTime: Date
    let temperature: Int
    let relativeHumidity: Int
    let apparentTemperature: Int
    let comfortIndex: Int
    let comfortIndexDescription: String
    let rainProbability: Int
    let weather: Int
    let weatherDescription: String
    let windSpeed: Int
    let windSpeedDirection: String
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "date_time"
        case temperature = "temperature"
        case relativeHumidity = "relative_humidity"
        case apparentTemperature = "apparent_temperature"
        case comfortIndex = "comfort_index"
        case comfortIndexDescription = "comfort_index_description"
        case rainProbability = "rain_probability"
        case weather = "weather"
        case weatherDescription = "weather_description"
        case windSpeed = "wind_speed"
        case windSpeedDirection = "wind_speed_direction"
    }
}
