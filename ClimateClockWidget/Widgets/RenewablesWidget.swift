//
//  ClimateClockWidget.swift
//  ClimateClockWidget
//
//  Created by Eric Wätke on 15.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import WidgetKit
import SwiftUI

struct RenewablesProvider: TimelineProvider {
	func placeholder(in context: Context) -> RenewablesEntry {
		RenewablesEntry(date: Date(), emoji: "😀")
	}

	func getSnapshot(in context: Context, completion: @escaping (RenewablesEntry) -> ()) {
		let entry = RenewablesEntry(date: Date(), emoji: "😀")
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [RenewablesEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = RenewablesEntry(date: entryDate, emoji: "😀")
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

struct RenewablesEntry: TimelineEntry {
	let date: Date
	let emoji: String
}

struct RenewablesWidgetEntryView : View {
	var entry: RenewablesProvider.Entry

	var body: some View {
		VStack {
			Text("Time:")
			Text(entry.date, style: .time)

			Text("Emoji:")
			Text(entry.emoji)
		}
	}
}

struct RenewablesWidget: Widget {
	let kind: String = "RenewablesWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: RenewablesProvider()) { entry in
			if #available(iOS 17.0, *) {
				RenewablesWidgetEntryView(entry: entry)
					.containerBackground(.fill.tertiary, for: .widget)
			} else {
				RenewablesWidgetEntryView(entry: entry)
					.padding()
					.background()
			}
		}
		.configurationDisplayName("My Widget")
		.description("This is an example widget.")
		.supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
	}
}

#Preview(as: .systemSmall) {
	RenewablesWidget()
} timeline: {
	RenewablesEntry(date: .now, emoji: "😀")
	RenewablesEntry(date: .now, emoji: "🤩")
}
