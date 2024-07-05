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
	@Environment(\.showsWidgetContainerBackground) var showsBackground
	
	var body: some View {
		VStack(alignment: .leading) {
			VStack {
				Text("\(valueByDate(date: entry.date), specifier: "%0.\(entry.precision)f") %")
					.font(
						.custom("Oswald", size: 20)
						.weight(.semibold)
					)
					.monospacedDigit()
					.lineLimit(1)
					.contentTransition(
						.numericText(
							value: valueByDate(date: entry.date)
						)
					)
					.foregroundStyle(.lifelineFg1)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 6)
					.padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
			}
			.frame(maxWidth: .infinity, alignment: .center)
			
			Spacer()
			
			RoundedRectangle(cornerRadius: 3)
							.frame(height: 21)
							.foregroundStyle(.foreground.opacity(0.25))
							.overlay(alignment: .leading) {
								GeometryReader { geometry in
									Rectangle()
										.frame(width: geometry.size.width * (valueByDate(date: entry.date) / 100), height: 21)
										.foregroundStyle(.lifelineFg1)
										.clipShape(RoundedRectangle(cornerRadius: 3))
										.widgetAccentable()
								}
							}
							.padding(.horizontal, 6)
							.padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
			
			Spacer()
			
			WidgetTitle(title: "Energy from Renewables", withBackground: false)
		}
		.containerRelativeFrame(.horizontal)
		.containerRelativeFrame(.vertical)
		.containerBackground(LinearGradient(colors: [.lifelineBg1, .lifelineBg2],
										 startPoint: .top,
											endPoint: .bottom), for: .widget)
		.background {
			if (showsBackground) {
				LinearGradient(colors: [.lifelineBg1, .lifelineBg2],
							   startPoint: .top,
							   endPoint: .bottom)
			} else {
				Color.clear
			}
		}
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
									precision: 6)
}
