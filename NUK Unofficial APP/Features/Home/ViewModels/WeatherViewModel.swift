//
//  WeatherViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/31.
//

import Foundation
import Combine
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weathers: [Weather] = []
    @Published var errorMessage: String? = nil
    
    @MainActor
    func getWeather() async -> Void {
        do {
            weathers = try await APIService.shared.fetch(endpoint: "/weather")
            errorMessage = nil
        } catch {
            weathers = []
            errorMessage = error.localizedDescription
        }
    }
    
    func isLoading() -> Bool {
        return weathers.isEmpty && errorMessage == nil
    }
    
    func getHourString(date: Date) -> String {
        let dayDifference: Int? = Calendar.current.dateComponents([.day], from: Date(), to: date).day
        let hour: Int = Calendar.current.component(.hour, from: date)
        if hour == 0 {
            if let dayDifference = dayDifference {
                switch dayDifference {
                case -2:
                    return String(localized: "common.date.twodaysago")
                case -1:
                    return String(localized: "common.date.yesterday")
                case 0:
                    return String(localized: "common.date.today")
                case 1:
                    return String(localized: "common.date.tomorrow")
                case 2:
                    return String(localized: "common.date.twodayslater")
                default:
                    return String(localized: "common.date.dayslater \(dayDifference)")
                }
            }
            return String(localized: "common.date.daysago 0")
        }
        return String(localized: "common.date.hour \(hour)")
    }
    
    func getWeatherIcon(dateTime: Date, weather: Int) -> AnyView {
        let hour: Int = Calendar.current.component(.hour, from: dateTime)
        var skyMode: String = "moon"
        
        if hour >= 6 && hour <= 18 {
            skyMode = "sun"
        }
        
        switch weather {
        case 1:
            return AnyView(
                Image(systemName: "\(skyMode == "sun" ? "sun.max.fill" : "moon.fill")")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("YELLOW"))
            )
            
        case 2...4:
            return AnyView(
                Image(systemName: "cloud.\(skyMode).fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("BLUE"), Color("YELLOW"))
                )
            
        case 5...6:
            return AnyView(
                Image(systemName: "smoke.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"))
            )
            
        case 7:
            return AnyView(
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"))
            )
            
        case 8...11:
            return AnyView(
                Image(systemName: "cloud.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"))
            )
            
        case 12...14:
            return AnyView(
                Image(systemName: "cloud.heavyrain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"))
            )
            
        case 15...18:
            return AnyView(
                Image(systemName: "cloud.bolt.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"), Color("YELLOW"))
            )
            
        case 19...22:
            return AnyView(
                Image(systemName: "cloud.\(skyMode).rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("YELLOW"), Color("BLUE"))
            )
            
        case 23:
            return AnyView(
                Image(systemName: "cloud.sleet.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"), Color("WHITE"))
            )
            
        case 24...27:
            return AnyView(
                Image(systemName: "\(skyMode == "sun" ? "sun.haze.fill" : "cloud.fog.fill")")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("\(skyMode == "sun" ? "YELLOW" : "LITTLE_DARK_GRAY")"))
            )
            
        case 28:
            return AnyView(
                Image(systemName: "cloud.fog.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("LITTLE_DARK_GRAY"))
            )
            
        case 29:
            return AnyView(
                Image(systemName: "cloud.\(skyMode).rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("YELLOW"), Color("BLUE"))
            )
            
        case 30:
            return AnyView(
                Image(systemName: "cloud.drizzle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"))
            )
            
        case 31:
            return AnyView(
                Image(systemName: "\(skyMode == "sun" ? "sun.haze.fill" : "cloud.fog.fill")")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("\(skyMode == "sun" ? "YELLOW" : "LITTLE_DARK_GRAY")"))
            )
            
        case 32:
            return AnyView(
                Image(systemName: "cloud.fog.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("LITTLE_DARK_GRAY"))
            )
            
        case 33:
            return AnyView(
                Image(systemName: "cloud.\(skyMode).bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("YELLOW"))
            )
            
        case 34:
            return AnyView(
                Image(systemName: "cloud.bolt.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"), Color("YELLOW"))
            )
            
        case 35...37:
            return AnyView(
                Image(systemName: "cloud.fog.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("LITTLE_DARK_GRAY"))
            )
            
        case 38:
            return AnyView(
                Image(systemName: "cloud.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"))
            )
            
        case 39:
            return AnyView(
                Image(systemName: "cloud.heavyrain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"))
            )
            
        // 氣象局本來就沒編號 40 的天氣狀況，超靠北
            
        case 41:
            return AnyView(
                Image(systemName: "cloud.bolt.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("BLUE"), Color("YELLOW"))
            )
            
        case 42:
            return AnyView(
                Image(systemName: "cloud.snow.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("LITTLE_DARK_GRAY"), Color("LITTLE_DARK_GRAY"))
            )

        default:
            return AnyView(
                Image(systemName: "exclamationmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("WHITE"), Color("LITTLE_DARK_GRAY"))
            )
        }
    }
}
