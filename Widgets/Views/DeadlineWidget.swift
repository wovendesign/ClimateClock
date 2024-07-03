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
		
		let entry = DeadlineEntry(date: date, deadline:"2029-07-22T16:00:00+00:00")
		
		// Create a date that's 15 minutes in the future.
		let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
		
		// Create the timeline with the entry and a reload policy with the date for the next update.
		let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
		
		// Call the completion to pass the timeline to WidgetKit.
		completion(timeline)
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
	@Environment(\.showsWidgetContainerBackground) var showsBackground
	
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
		
		VStack(alignment: .leading) {
			VStack(alignment: .center) {
					Text("\(diff(deadline: entry.deadline).years) years \(diff(deadline: entry.deadline).days) days")
					.font(
						.custom("Oswald", size: 20)
						.weight(.semibold)
					)
					.monospacedDigit()
					.lineLimit(1)
					.allowsTightening(true)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 6)
					.padding(EdgeInsets(top: -2, leading: 0, bottom: -12, trailing: 0))
				
				Text(isTomorrow ? tomorrowTimer : todayTimer, style: .timer)
					.font(
						.custom("Oswald", size: 20)
					)
					.monospacedDigit()
					.lineLimit(1)
					.contentTransition(
						.numericText(countsDown: true)
					)
					.padding(.leading, -4)
					.widgetAccentable()
					.multilineTextAlignment(.center)
					.padding(.horizontal, 6)
					.padding(EdgeInsets(top: 0, leading: 0, bottom: -12, trailing: 0))
			}
			.foregroundStyle(.deadlineForeground1)
			
			Spacer()
			
			WidgetTitle(title: "1.5 °C Deadline", withBackground: true)
		}
		.containerRelativeFrame(.horizontal)
		.containerRelativeFrame(.vertical)
		.widgetBackground(LinearGradient(colors: [.deadlineBackground1, .deadlineBackground2],
										 startPoint: .top,
										 endPoint: .bottom))
		.background {
			if (showsBackground) {
				LinearGradient(colors: [.deadlineBackground1, .deadlineBackground2],
							   startPoint: .top,
							   endPoint: .bottom)
			} else {
				Color.clear
			}
		}
	}
}

struct DeadlineWidget: Widget {
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
	DeadlineWidget()
} timeline: {
	DeadlineEntry(date: .now, deadline: "2029-07-22T16:00:00+00:00")
}
