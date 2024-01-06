//
//  Deadline_Complication.swift
//  Deadline Complication
//
//  Created by Eric Wätke on 05.01.24.
//

import WidgetKit
import SwiftUI

struct DeadlineProvider: TimelineProvider {
    func placeholder(in context: Context) -> DeadlineEntry {
        return DeadlineEntry(date: .now, deadline:"2029-07-22T16:00:00+00:00")
    }
    
    //    var hasFetchedDeadlineData: Bool
    //    var deadlineData: String
    
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let date = Date()
        let entry: DeadlineEntry
        
        
        entry = DeadlineEntry(date: date, deadline:"2029-07-22T16:00:00+00:00")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DeadlineEntry>) -> Void) {
        // Create a timeline entry for "now."
        let date = Date()
        
        get_data { deadlineContent in
            let entry = DeadlineEntry(date: date, deadline: deadlineContent)
            
            // Create a date that's 15 minutes in the future.
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
            
            // Create the timeline with the entry and a reload policy with the date for the next update.
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
            
            // Call the completion to pass the timeline to WidgetKit.
            completion(timeline)
        }
    }
}

struct DeadlineContent {
    let years: Int
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
}

struct DeadlineEntry: TimelineEntry {
    let date: Date
    let deadline: String
}

struct ClimateClockAPIData: Decodable {
    let title: String
}

func parseDateString(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter.date(from: dateString)
}
func dateDiff(deadline: Date, now: Date) -> DateComponents {
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: deadline)
    
    return components
}

func get_data(completion: @escaping (String) -> Void) {
    let url = URL(string: "https://api.climateclock.world/v2/widget/clock.json")!
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
    
    var clock_data: ClimateClockData?
    
    print("test")
    
    URLSession.shared.dataTask(with: request) {(data, response, error) in
        guard let data = data else {
            completion("2039-07-22T16:00:00+00:00")
            return
        }
        
        do {
            guard let json = String(data: data, encoding: .utf8) else { return }
            clock_data = parseJSON(json: json)
            
            if let clock_data = clock_data {
                completion(clock_data.modules.carbonDeadlines.timestamp)
            } else {
                completion("2059-07-22T16:00:00+00:00")
            }
        }
    }.resume()
}

func diff(deadline: String) -> DeadlineContent {
    if let deadline = parseDateString(deadline) {
        let now = Date()
        
        let diffComponents = dateDiff(deadline: deadline, now: now)
        
        return DeadlineContent(
            years: diffComponents.year ?? 0,
            days: diffComponents.day ?? 4,
            hours: diffComponents.hour ?? 0,
            minutes: diffComponents.minute ?? 0,
            seconds: diffComponents.second ?? 0)
    } else {
        return DeadlineContent(years: 0, days: 5, hours: 0, minutes: 0, seconds: 0)
    }
}

struct Deadline_ComplicationEntryView : View {
    var entry: DeadlineProvider.Entry
    
    var body: some View {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let year = Calendar.current.component(.year, from: tomorrow)
        let month = Calendar.current.component(.month, from: tomorrow)
        let day = Calendar.current.component(.day, from: tomorrow)
        let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0)

        let timer = Calendar.current.date(from: components)!
        
        
        HStack {
            
            HStack(alignment: .firstTextBaseline, content: {
                Text(String(diff(deadline: entry.deadline).years)).font(.custom("Times New Roman", size: 32)).foregroundStyle(.red).fontWidth(.compressed)
//                Text("Y").font(.system(size: 16)).foregroundStyle(.red).fontWidth(.compressed)
            })
            HStack(alignment: .firstTextBaseline, content: {
                Text(String(diff(deadline: entry.deadline).days))
                    .font(.system(size: 32, design: .none).width(.compressed))
                    .foregroundStyle(.red)
                    .fontWidth(.compressed)
                    .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                Text("D").font(.system(size: 16)).foregroundStyle(.orange).fontWidth(.compressed)
            })
            Text(timer, style: .timer).font(.system(size: 32)).foregroundStyle(.orange).fontWidth(.compressed).allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
    }
}

@main
struct DeadlineComplications: WidgetBundle {
    var body: some Widget {
        Deadline_Complication()
    }
}


struct Deadline_Complication: Widget {
    let kind: String = "Deadline_Complication"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DeadlineProvider()) { entry in
            Deadline_ComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Game Status")
        .description("Shows an overview of your game status")
        .supportedFamilies([.accessoryRectangular])
    }
}



#Preview(as: .accessoryRectangular) {
    Deadline_Complication()
} timeline: {
    DeadlineEntry(date: .now, deadline: "2029-07-22T16:00:00+00:00")
}
