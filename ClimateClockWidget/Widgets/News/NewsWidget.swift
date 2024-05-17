//
//  ClimateClockWidget.swift
//  ClimateClockWidget
//
//  Created by Eric Wätke on 15.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NewsWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> NewsWidgetEntry {
		NewsWidgetMockData().mockEntry
	}

	func getSnapshot(in context: Context, completion: @escaping (NewsWidgetEntry) -> ()) {
		let entry = NewsWidgetMockData().mockEntry
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [NewsWidgetEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = NewsWidgetMockData().mockEntry
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

struct NewsWidgetEntry: TimelineEntry {
	let date: Date
	
	let relativeDate: String
	let headline: String
	let source: String
}

struct NewsWidgetEntryView : View {
	var entry: NewsWidgetProvider.Entry

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			RelativeTimeCell(pushDate: entry.date)
			Text(entry.headline)
				.font(
					.custom("Oswald", size: 16)
						.weight(.regular)
				)
				.tracking(0.32)
				.frame(maxWidth: .infinity, alignment: .leading)

			Text(entry.source)
				.font(
					.custom("Assistant", size: 12)
						.weight(.semibold)
				)
				.foregroundStyle(Color.gray)
		}
	}
}

struct NewsWidget: Widget {
	let kind: String = "ClimateClockWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: NewsWidgetProvider()) { entry in
			if #available(iOS 17.0, *) {
				NewsWidgetEntryView(entry: entry)
					.containerBackground(.fill.tertiary, for: .widget)
			} else {
				NewsWidgetEntryView(entry: entry)
					.padding()
					.background()
			}
		}
		.configurationDisplayName("My Widget")
		.description("This is an example widget.")
	}
}

#Preview(as: .systemSmall) {
	NewsWidget()
} timeline: {
	NewsWidgetMockData().mockEntry
}


struct NewsWidgetMockData {
	let mockEntry = NewsWidgetEntry(
		date: Date(),
		relativeDate: "Today",
		headline: "UK pledges $6m to back climate-smart farming in Zambia & curb deforestation",
		source: "The New York Times")
}
