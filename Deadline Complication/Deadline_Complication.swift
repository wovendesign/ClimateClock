//
//  Deadline_Complication.swift
//  Deadline Complication
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
import WidgetKit

struct DeadlineProvider: TimelineProvider {
    func placeholder(in _: Context) -> DeadlineEntry {
        return DeadlineEntry(date: .now, deadline: "2029-07-22T16:00:00+00:00")
    }

    //    var hasFetchedDeadlineData: Bool
    //    var deadlineData: String

    func getSnapshot(in _: Context, completion: @escaping (Entry) -> Void) {
        let date = Date()
        let entry: DeadlineEntry

        entry = DeadlineEntry(date: date, deadline: "2029-07-22T16:00:00+00:00")
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<DeadlineEntry>) -> Void) {
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

func get_data(completion _: @escaping (String) -> Void) {
    let url = URL(string: "https://api.climateclock.world/v2/widget/clock.json")!
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)

    var clock_data: ClimateClockData?

    print("test")

//    URLSession.shared.dataTask(with: request) {(data, response, error) in
//        guard let data = data else {
//            completion("2039-07-22T16:00:00+00:00")
//            return
//        }
//
//        do {
//            guard let json = String(data: data, encoding: .utf8) else { return }
//            clock_data = parseJSON(json: json)
//
//            if let clock_data = clock_data {
//                completion(clock_data.modules.carbonDeadlines.timestamp)
//            } else {
//                completion("2059-07-22T16:00:00+00:00")
//            }
//        }
//    }.resume()
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
            seconds: diffComponents.second ?? 0
        )
    } else {
        return DeadlineContent(years: 0, days: 5, hours: 0, minutes: 0, seconds: 0)
    }
}

struct Deadline_ComplicationEntryView: View {
    var entry: DeadlineProvider.Entry

    var body: some View {
        let deadline = Calendar.current.dateComponents([.hour, .minute], from: parseDateString(entry.deadline)!)

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
        let tomorrowTimerComponents = DateComponents(
            year: tomorrowComponents.year ?? 0,
            month: tomorrowComponents.month ?? 0,
            day: tomorrowComponents.day,
            hour: deadline.hour,
            minute: deadline.minute
        )
        let todayTimerComponents = DateComponents(
            year: todayComponents.year ?? 0,
            month: todayComponents.month ?? 0,
            day: todayComponents.day,
            hour: deadline.hour,
            minute: deadline.minute
        )

        let tomorrowTimer = Calendar.current.date(from: tomorrowTimerComponents)!
        let isTomorrow = Calendar.current.isDateInToday(tomorrowTimer)
        let todayTimer = Calendar.current.date(from: todayTimerComponents)!

        VStack(
            alignment: .leading
        ) {
            HStack {
                Spacer()
                Text("1,5˚C Deadline")
                    .font(.custom("Assistant", size: 14))
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack(
                spacing: 2
            ) {
                Spacer()
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 0
                ) {
                    Text(String(diff(deadline: entry.deadline).years))
                        
                        .font(.custom("Oswald", size: 22))
                        .foregroundStyle(.red)
                        .fontWidth(.compressed)
                        .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    Text("years")
                        .font(.custom("Oswald", size: 22))
                        .foregroundStyle(.red)
                        .fontWidth(.compressed)
                }
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 0
                ) {
                    Text(String(diff(deadline: entry.deadline).days))
                        .font(.custom("Oswald", size: 22))
                        .foregroundStyle(.orange)
                        .fontWidth(.compressed)
                        .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    Text("days")
                        .font(.custom("Oswald", size: 22))
                        .foregroundStyle(.orange)
                        .fontWidth(.compressed)
                }
                Spacer()
            }
            HStack {
                Spacer()
            Text(isTomorrow ? tomorrowTimer : todayTimer, style: .timer)
                .font(.custom("Oswald", size: 22))
                .foregroundStyle(.yellow)
                .fontWidth(.compressed)
                .monospacedDigit()
                .kerning(-1)
                .widgetAccentable()
            }
        }
    }
}

@main
struct DeadlineComplications: WidgetBundle {
    var body: some Widget {
        Deadline_Complication()
        //			Lifeline
    }
}

struct Deadline_Complication: Widget {
    let kind: String = "Deadline_Complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DeadlineProvider()) { entry in
            Deadline_ComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("1,5˚C Deadline")
        .description("Shows remaining time to reach 1,5˚C goal")
        .supportedFamilies([.accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    Deadline_Complication()
} timeline: {
    DeadlineEntry(date: .now, deadline: "2029-07-22T16:00:00+00:00")
}
