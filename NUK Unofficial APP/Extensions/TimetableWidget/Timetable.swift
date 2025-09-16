//
//  Timetable.swift
//  TimetableWidget
//
//  Created by Hao-Quan Liu on 2022/7/27.
//

import WidgetKit
import SwiftUI

struct TimetableEntry: TimelineEntry {
    let date: Date
    let nowColor: Color
    let nowCourseName: String
    let nowCourseTime: String
    let nowCourseRoom: String
    let nextColor: Color
    let nextCourseName: String
    let nextCourseTime: String
    let nextCourseRoom: String
}

struct Provider: TimelineProvider {
    // 取得現在是第幾節課
    func getNowSection(minute: Int) -> Int? {
        var section: Int? = nil
        if minute >= 425, minute < 475 {
            section = 0
        } else if minute >= 485, minute < 535 {
            section = 1
        } else if minute >= 545, minute < 595 {
            section = 2
        } else if minute >= 610, minute < 660 {
            section = 3
        } else if minute >= 670, minute < 720 {
            section = 4
        } else if minute >= 730, minute < 780 {
            section = 5
        } else if minute >= 790, minute < 840 {
            section = 6
        } else if minute >= 850, minute < 900 {
            section = 7
        } else if minute >= 915, minute < 965 {
            section = 8
        } else if minute >= 980, minute < 1030 {
            section = 9
        } else if minute >= 1040, minute < 1090 {
            section = 10
        } else if minute >= 1100, minute < 1150 {
            section = 11
        } else if minute >= 1155, minute < 1205 {
            section = 12
        } else if minute >= 1210, minute < 1260 {
            section = 13
        } else if minute >= 1265, minute < 1315 {
            section = 14
        }
        return section
    }
    
    // 取得下一堂課是第幾節課
    func getNextSection(timetable: [[Course?]], weekDay: Int, minute: Int) -> Int? {
        if weekDay < 0 {
            return nil
        }
        var section: Int = 0
        if minute < 425 {
            section = 0
        } else if minute < 485 {
            section = 1
        } else if minute < 545 {
            section = 2
        } else if minute < 610 {
            section = 3
        } else if minute < 670 {
            section = 4
        } else if minute < 730 {
            section = 5
        } else if minute < 790 {
            section = 6
        } else if minute < 850 {
            section = 7
        } else if minute < 915 {
            section = 8
        } else if minute < 980 {
            section = 9
        } else if minute < 1040 {
            section = 10
        } else if minute < 1100 {
            section = 11
        } else if minute < 1155 {
            section = 12
        } else if minute < 1210 {
            section = 13
        } else if minute < 1265 {
            section = 14
        } else {
            section = 15
        }
        while section <= 14 {
            if timetable[weekDay][section] != nil {
                break
            }
            section = section + 1
        }
        if section > 14 {
            return nil
        }
        return section
    }
    
    // 取得上課時間
    func getCourseTime(section: Int?) -> String {
        var courseTime: String = "未知"
        if let section = section {
            switch(section) {
            case 0:
                courseTime = "07:05"
            case 1:
                courseTime = "08:05"
            case 2:
                courseTime = "09:05"
            case 3:
                courseTime = "10:10"
            case 4:
                courseTime = "11:10"
            case 5:
                courseTime = "12:10"
            case 6:
                courseTime = "13:10"
            case 7:
                courseTime = "14:10"
            case 8:
                courseTime = "15:15"
            case 9:
                courseTime = "16:20"
            case 10:
                courseTime = "17:20"
            case 11:
                courseTime = "18:20"
            case 12:
                courseTime = "19:15"
            case 13:
                courseTime = "20:10"
            case 14:
                courseTime = "21:05"
            default:
                courseTime = "未知"
            }
        }
        return courseTime
    }
    
    // 取得現在課程名稱
    func getNowCourseName(timetable: [[Course?]], weekDay: Int, minute: Int) -> String {
        var courseName: String = "無課程"
        if weekDay >= 0 {
            let nowSection: Int? = getNowSection(minute: minute)
            if let nowSection = nowSection {
                if let course = timetable[weekDay][nowSection] {
                    courseName = course.name
                }
            } else if minute > 425, minute < 1315 {
                courseName = "下課休息"
            }
        }
        return courseName
    }
    
    // 取得下一堂課程名稱
    func getNextCourseName(timetable: [[Course?]], weekDay: Int, minute: Int) -> String {
        var courseName: String = "今天沒課囉"
        if weekDay >= 0 {
            let nextSection: Int? = getNextSection(timetable: timetable, weekDay: weekDay, minute: minute)
            if let nextSection = nextSection {
                if let course = timetable[weekDay][nextSection] {
                    courseName = course.name
                }
            }
        }
        return courseName
    }
    
    // 取得現在課程教室
    func getNowCourseRoom(timetable: [[Course?]], weekDay: Int, minute: Int) -> String {
        var courseRoom: String = ""
        if weekDay >= 0 {
            let nextSection: Int? = getNowSection(minute: minute)
            if let nextSection = nextSection {
                if let course = timetable[weekDay][nextSection] {
                    courseRoom = course.classroom ?? "未公佈"
                }
            }
        }
        return courseRoom
    }
    
    // 取得下節課程教室
    func getNextCourseRoom(timetable: [[Course?]], weekDay: Int, minute: Int) -> String {
        var courseRoom: String = ""
        if weekDay >= 0 {
            let nextSection: Int? = getNextSection(timetable: timetable, weekDay: weekDay, minute: minute)
            if let nextSection = nextSection {
                if let course = timetable[weekDay][nextSection] {
                    courseRoom = course.classroom ?? "未公佈"
                }
            }
        }
        return courseRoom
    }
    
    // 取得現在課程類別顏色
    func getNowColor(timetable: [[Course?]], weekDay: Int, minute: Int) -> Color {
        let section: Int? = getNowSection(minute: minute)
        if let section = section, weekDay >= 0 {
            let course: Course? = timetable[weekDay][section]
            if let course = course {
                return Color("\(course.getCourseCategory().getColor())")
            }
            return Color("TIMETABLE_LITTLE_DARK_GRAY")
        }
        return Color("TIMETABLE_LITTLE_DARK_GRAY")
    }
    
    // 取得下一節課程類別顏色
    func getNextColor(timetable: [[Course?]], weekDay: Int, minute: Int) -> Color {
        let section: Int? = getNextSection(timetable: timetable, weekDay: weekDay, minute: minute)
        if let section = section, weekDay >= 0 {
            let course: Course? = timetable[weekDay][section]
            if let course = course {
                return Color("\(course.getCourseCategory().getColor())")
            }
            return Color("TIMETABLE_LITTLE_DARK_GRAY")
        }
        return Color("TIMETABLE_LITTLE_DARK_GRAY")
    }
    
    // 在沒有資料的時候秀出的東西
    func placeholder(in context: Context) -> TimetableEntry {
        TimetableEntry(date: Date(), nowColor: Color("TIMETABLE_LITTLE_DARK_GRAY"), nowCourseName: "無資料", nowCourseTime: "未知", nowCourseRoom: "", nextColor: Color("TIMETABLE_LITTLE_DARK_GRAY"), nextCourseName: "無資料", nextCourseTime: "未知", nextCourseRoom: "")
    }
    
    // 查看即時 Widget 快照（在用戶選擇的時候會秀出）
    func getSnapshot(in context: Context, completion: @escaping (TimetableEntry) -> ()) {
        var timetable: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
        let timetableFromKeychain: [[Course?]]? = KeychainManager.shared.get(key: "timetable_confirmed", type: [[Course?]].self)
        if let timetableFromKeychain = timetableFromKeychain {
            timetable = timetableFromKeychain
        }
        var weekDay: Int = Calendar.current.dateComponents(in: TimeZone.current, from: Date()).weekday!
        if weekDay == 1 {
            weekDay = 6
        } else {
            weekDay = weekDay - 2
        }
        let minute: Int = Calendar.current.component(.hour, from: Date()) * 60 + Calendar.current.component(.minute, from: Date())
        let nowColor: Color = getNowColor(timetable: timetable, weekDay: weekDay, minute: minute)
        let nowCourseName: String = getNowCourseName(timetable: timetable, weekDay: weekDay, minute: minute)
        let nowCourseTime: String = getCourseTime(section: getNowSection(minute: minute))
        let nowCourseRoom: String = getNowCourseRoom(timetable: timetable, weekDay: weekDay, minute: minute)
        let nextColor: Color = getNextColor(timetable: timetable, weekDay: weekDay, minute: minute)
        let nextCourseName: String = getNextCourseName(timetable: timetable, weekDay: weekDay, minute: minute)
        let nextCourseTime: String = getCourseTime(section: getNextSection(timetable: timetable, weekDay: weekDay, minute: minute))
        let nextCourseRoom: String = getNextCourseRoom(timetable: timetable, weekDay: weekDay, minute: minute)
        let entry = TimetableEntry(date: Date(), nowColor: nowColor, nowCourseName: nowCourseName, nowCourseTime: nowCourseTime, nowCourseRoom: nowCourseRoom, nextColor: nextColor, nextCourseName: nextCourseName, nextCourseTime: nextCourseTime, nextCourseRoom: nextCourseRoom)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // 初始化課表
        var timetable: [[Course?]] = [[Course?]](repeating: [Course?](repeating: nil, count: 15), count: 7)
        // 從 KeyChain 取得使用者的課表
        let timetableFromKeychain: [[Course?]]? = KeychainManager.shared.get(key: "timetable_confirmed", type: [[Course?]].self)
        if let timetableFromKeychain = timetableFromKeychain {
            timetable = timetableFromKeychain
        }
        var entries: [TimetableEntry] = []
        let currentDate: Date = Date()
        let midnight: Date = Calendar.current.startOfDay(for: currentDate)
        let nextTwoDay: Date = Calendar.current.date(byAdding: .day, value: 2, to: midnight)!
        
        // 一次讀兩天的資料
        for dayOffset in 0..<2 {
            let preEntryDate: Date = Calendar.current.date(byAdding: .day, value: dayOffset, to: midnight)!
            // 要設置 Timeline Entry 的時間點
            let minuteOffsets: [Int] = [0, 425, 475, 485, 535, 545, 595, 610, 660, 670, 720, 730, 780, 790, 840, 850, 900, 915, 965, 980, 1030, 1040, 1090, 1100, 1150, 1155, 1205, 1210, 1260, 1265, 1315]
            for minuteOffset in minuteOffsets {
                let entryDate: Date = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: preEntryDate)!
                var weekDay: Int = Calendar.current.dateComponents(in: TimeZone.current, from: entryDate).weekday!
                if weekDay == 1 {
                    weekDay = 6
                } else {
                    weekDay = weekDay - 2
                }
                let minute: Int = Calendar.current.component(.hour, from: entryDate) * 60 + Calendar.current.component(.minute, from: entryDate)
                let nowColor: Color = getNowColor(timetable: timetable, weekDay: weekDay, minute: minute)
                let nowCourseName: String = getNowCourseName(timetable: timetable, weekDay: weekDay, minute: minute)
                let nowCourseTime: String = getCourseTime(section: getNowSection(minute: minute))
                let nowCourseRoom: String = getNowCourseRoom(timetable: timetable, weekDay: weekDay, minute: minute)
                let nextColor: Color = getNextColor(timetable: timetable, weekDay: weekDay, minute: minute)
                let nextCourseName: String = getNextCourseName(timetable: timetable, weekDay: weekDay, minute: minute)
                let nextCourseTime: String = getCourseTime(section: getNextSection(timetable: timetable, weekDay: weekDay, minute: minute))
                let nextCourseRoom: String = getNextCourseRoom(timetable: timetable, weekDay: weekDay, minute: minute)
                let entry = TimetableEntry(date: entryDate, nowColor: nowColor, nowCourseName: nowCourseName, nowCourseTime: nowCourseTime, nowCourseRoom: nowCourseRoom, nextColor: nextColor, nextCourseName: nextCourseName, nextCourseTime: nextCourseTime, nextCourseRoom: nextCourseRoom)
                entries.append(entry)
            }
        }
        // 三天後再讀一次資料
        let timeline = Timeline(entries: entries, policy: .after(nextTwoDay))
        completion(timeline)
    }
}

struct TimetableEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack {
                Text("NUK APP")
                    .font(.system(size: 14))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("NUK_ORANGE"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxHeight: .infinity, alignment: .top)
                VStack(spacing: 10) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 6, height: 20)
                            .foregroundColor(entry.nowColor)
                        VStack(spacing: 0) {
                            Text("現在課程\(entry.nowCourseTime != "未知" ? "[\(entry.nowCourseTime)]" : "")")
                                .font(.system(size: 12, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            Text("\(entry.nowCourseName)")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                        }
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 6, height: 20)
                            .foregroundColor(entry.nextColor)
                        VStack(spacing: 0) {
                            Text("下一節課\(entry.nextCourseTime != "未知" ? "[\(entry.nextCourseTime)]" : "")")
                                .font(.system(size: 12, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            Text("\(entry.nextCourseName)")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .padding(15)
            .frame(maxHeight: .infinity, alignment: .top)
            .containerBackground(Color("WHITE"), for: .widget)
            
        case .systemMedium:
            ZStack {
                Text("NUK APP")
                    .font(.system(size: 14))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("NUK_ORANGE"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxHeight: .infinity, alignment: .top)
                VStack(spacing: 10) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 6, height: 20)
                            .foregroundColor(entry.nowColor)
                        VStack(spacing: 0) {
                            Text("現在課程\(entry.nowCourseTime != "未知" ? "[\(entry.nowCourseTime)]" : "")")
                                .font(.system(size: 12, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            Text("\(entry.nowCourseName)")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                        }
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 6, height: 20)
                            .foregroundColor(entry.nextColor)
                        VStack(spacing: 0) {
                            Text("下一節課\(entry.nextCourseTime != "未知" ? "[\(entry.nextCourseTime)]" : "")")
                                .font(.system(size: 12, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            Text("\(entry.nextCourseName)")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .padding(15)
            .frame(maxHeight: .infinity, alignment: .top)
            .containerBackground(Color("WHITE"), for: .widget)
            
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 3) {
                    Image(systemName: "text.book.closed.fill")
                    Text("下一節課\(entry.nextCourseTime != "未知" ? "[\(entry.nextCourseTime)]" : "")")
                        .font(.system(size: 14, design: .monospaced))
                        .fontWeight(.bold)
                }
                Text("\(entry.nextCourseName)")
                    .font(.system(size: 14))
                Text("\(entry.nextCourseRoom)")
                    .font(.system(size: 14, design: .monospaced))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .containerBackground(Color("WHITE"), for: .widget)
            
        default:
            EmptyView()
        }
    }
}

@main
struct Timetable: Widget {
    var body: some WidgetConfiguration {
        let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium, .accessoryRectangular]
        return StaticConfiguration(kind: "Timetable", provider: Provider()) { entry in
            TimetableEntryView(entry: entry)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("個人課表")
        .description("查看即將迎來的課程")
        .supportedFamilies(supportedFamilies)
    }
}

struct Timetable_Previews: PreviewProvider {
    static var previews: some View {
        TimetableEntryView(entry: TimetableEntry(date: Date(), nowColor: Color("TIMETABLE_LITTLE_DARK_GRAY"), nowCourseName: "離散數學嗨嗨嗨嗨", nowCourseTime: "12:10", nowCourseRoom: "123", nextColor: Color("TIMETABLE_LITTLE_DARK_GRAY"), nextCourseName: "微積分嗨嗨嗨嗨嗨", nextCourseTime: "13:10", nextCourseRoom: "456"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
