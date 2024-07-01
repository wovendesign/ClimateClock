//
//  NewsWidget.swift
//  ClimateClockWidget
//
//  Created by Eric Wätke on 15.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwiftData

struct NewsWidgetProvider: TimelineProvider {
    func placeholder(in _: Context) -> NewsWidgetEntry {
        NewsWidgetMockData().mockEntry
    }

    func getSnapshot(in _: Context, completion: @escaping (NewsWidgetEntry) -> Void) {
        let entry = NewsWidgetMockData().mockEntry
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
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

struct NewsWidgetEntryView: View {
    var entry: NewsWidgetProvider.Entry
	
	static var now: Date { Date.now }
	
	static var descriptor: FetchDescriptor<NewsItem> {
		var descriptor = FetchDescriptor<NewsItem>(
			predicate: #Predicate<NewsItem> { $0.pushDate ?? now < now },
			sortBy: [SortDescriptor(\.pushDate, order: .reverse)])
		descriptor.fetchLimit = 1
		return descriptor
	}
	@Query(descriptor) var news: [NewsItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
			HStack(spacing: 4) {
				Image(systemName: "globe.central.south.asia.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 11, height: 11)
				
				Text(" NEWS OF HOPE")
					.font(
						.custom("Assistant", size: 14)
						.weight(.bold)
					)
					.opacity(0.5)
			}
			if let newsItem = news.first {
				Text(newsItem.headline)
					.font(
						.custom("Assistant", size: 13)
						.weight(.semibold)
						.leading(.tight)
					)
					.tracking(0.32)
					.frame(height: 50)
					.foregroundStyle(.foreground)
					.environment(\._lineHeightMultiple, 0.9)
			}
        }
		.containerRelativeFrame(.horizontal)
		.containerRelativeFrame(.vertical)
		.padding(.vertical, 2)
		.padding(.horizontal, 6)
		.onAppear {
			print(news)
		}
    }
}

struct NewsWidget: Widget {
    let kind: String = "NewsWidget"
	
	// SwiftData Container
	let container: ModelContainer = {
		let schema = Schema([NewsItem.self])
		let container = try! ModelContainer(for: schema, configurations: [])
		return container
	}()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NewsWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                NewsWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
					.modelContainer(container)
            } else {
                NewsWidgetEntryView(entry: entry)
                    .padding()
                    .background()
					.modelContainer(container)
            }
        }
        .configurationDisplayName("News Widget")
        .description("This is an example widget.")
		#if os(watchOS)
			.supportedFamilies([.accessoryRectangular])
		#else
			.supportedFamilies([.accessoryRectangular, .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
		#endif
    }
}

//#Preview(as: .systemSmall) {
#Preview(as: .accessoryRectangular) {
    NewsWidget()
} timeline: {
    NewsWidgetMockData().mockEntry
}

struct NewsWidgetMockData {
    let mockEntry = NewsWidgetEntry(
        date: Date(),
        relativeDate: "Today",
        headline: "UK pledges $6m to back climate-smart farming in Zambia & curb deforestation",
        source: "The New York Times"
    )
}
