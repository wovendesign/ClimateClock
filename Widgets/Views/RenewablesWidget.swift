//
//  RenewablesWidget.swift
//  ClimateClockWidget
//
//  Created by Eric Wätke on 15.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RenewablesProvider: TimelineProvider {
    func placeholder(in _: Context) -> RenewablesEntry {
        RenewablesWidgetMockData().mockEntry
    }

    func getSnapshot(in _: Context, completion: @escaping (RenewablesEntry) -> Void) {
        let entry = RenewablesWidgetMockData().mockEntry
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [RenewablesEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = RenewablesWidgetMockData().mockEntry
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct RenewablesEntry: TimelineEntry {
    let date: Date
    let timestamp: Date
    let initial: Double
    let rate: Double
    let precision: Int

    init(date: Date, timestamp: String, initial: Double, rate: Double, precision: Int) {
        let dateFormatter = ISO8601DateFormatter()

        let pastTimestamp = dateFormatter.date(from: timestamp) ?? Date()

        self.date = date
        self.timestamp = pastTimestamp
        self.initial = initial
        self.rate = rate
        self.precision = precision
    }
}

struct RenewablesWidgetEntryView: View {
    var entry: RenewablesProvider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(valueByDate(date: entry.date), specifier: "%0.\(entry.precision)f") %")
                .font(
                    .custom("Oswald", size: 20)
                        .weight(.semibold)
                )
                .monospacedDigit()
                //				.minimumScaleFactor(0.5)
                .lineLimit(1)
                .contentTransition(
                    .numericText(
                        value: valueByDate(date: entry.date)
                    )
                )

            RoundedRectangle(cornerRadius: 6)
                .containerRelativeFrame(.horizontal)
				.frame(height: 12)
                .foregroundStyle(.windowBackground)
				.opacity(0.5)
				.overlay {
					RoundedRectangle(cornerRadius: 6)
						.stroke(lineWidth: 2)
						.foregroundStyle(.foreground)
				}
                .overlay(alignment: .leading) {
                    Rectangle()
                        .containerRelativeFrame(.horizontal) { length, _ in
                            length * (valueByDate(date: entry.date) / 100)
                        }
						.clipShape(.rect(cornerRadius: 6))
						.padding(2)
						.foregroundStyle(.foreground)
                }
                .clipShape(.rect(cornerRadius: 6))

            Text("Energy from renewables")
                .textCase(.uppercase)
                .font(
                    .custom("Assistant", size: 12)
                        .weight(.semibold)
                )
        }
		.containerBackground(.blue, for: .widget)
    }

    func valueByDate(date: Date) -> Double {
        let timeDifference = date.timeIntervalSince(entry.timestamp)

        return entry.initial + timeDifference * (entry.rate)
    }
}

struct RenewablesWidget: Widget {
    let kind: String = "RenewablesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RenewablesProvider()) { entry in
            if #available(iOS 17.0, *) {
                RenewablesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
//					.containerBackground(.blue, for: .widget)
            } else {
                RenewablesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Renewables Widget")
        .description("This is an example widget.")
		#if os(watchOS)
			.supportedFamilies([.accessoryRectangular])
		#else
			.supportedFamilies([.accessoryRectangular, .systemSmall])
		#endif
    }
}

//#Preview(as: .systemSmall) {
//    RenewablesWidget()
//} timeline: {
//    RenewablesWidgetMockData().mockEntry
//}

//
// #Preview("Watch", as: .accessoryRectangular) {
//	RenewablesWidget()
// } timeline: {
//	RenewablesEntry(date: .now, emoji: "😀")
// }

struct RenewablesWidgetMockData {
    let mockEntry = RenewablesEntry(date: Date(),
                                    timestamp: "2020-01-01T00:00:00+00:00",
                                    initial: 11.4,
                                    rate: 2.0428359571070087e-8,
                                    precision: 5)
}
