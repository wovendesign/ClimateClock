//
//  LifelineComplication.swift
//  Deadline Complication
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
import WidgetKit

struct LifelineProvider: TimelineProvider {
    func placeholder(in _: Context) -> LifelineEntry {
        return LifelineMockData.sample_data
    }

    //    var hasFetchedDeadlineData: Bool
    //    var deadlineData: String

    func getSnapshot(in _: Context, completion: @escaping (Entry) -> Void) {
        let entry = LifelineMockData.sample_data
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<LifelineEntry>) -> Void) {
        // Create a timeline entry for "now."

        let entry = LifelineMockData.sample_data

        // Create a date that's 15 minutes in the future.
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!

        // Create the timeline with the entry and a reload policy with the date for the next update.
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))

        // Call the completion to pass the timeline to WidgetKit.
        completion(timeline)
    }
}

struct LifelineContent {
    let years: Int
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
}

struct LifelineEntry: TimelineEntry {
    let date: Date
    let label: String
    let value: Double
    let unit: String
}

struct ClimateClockAPIData: Decodable {
    let title: String
}

struct LifelineComplicationEntryView: View {
    var entry: LifelineProvider.Entry

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            HStack {
                Image(systemName: "flame.circle.fill")
                Text("1,5˚C Deadline").font(.headline)
            }
            HStack(
                spacing: 6
            ) {
                Text("\(entry.value)")
                    .font(.system(size: 28))
                    .foregroundStyle(.yellow)
                    .fontWidth(.compressed)
                    .monospacedDigit()
                    .kerning(-1)
                    .padding(.leading, -4)
                    .widgetAccentable()
            }
        }
    }
}

struct LifelineComplication: Widget {
    let kind: String = "Deadline_Complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifelineProvider()) { entry in
            LifelineComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("1,5˚C Deadline")
        .description("Shows remaining time to reach 1,5˚C goal")
        .supportedFamilies([.accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    LifelineComplication()
} timeline: {
    LifelineMockData.sample_data
}
