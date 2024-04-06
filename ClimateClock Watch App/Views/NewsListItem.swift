//
//  NewsListItem.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 03.04.24.
//

import SwiftUI

struct NewsListItem: View {
	@State var sheetOpen = false
	@ObservedObject var newsController: NewsController
	
	let newsItem: NewsItem
	
	var relativeDate: String {
		let pushDate = newsItem.pushDate
		guard let pushDate else {
			return "No Date"
		}

		if pushDate.distance(to: Date()) < 86_400 {
			return "TODAY"
		}
		return pushDate.formatted(.relative(presentation: .named))
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			RelativeTimeCell(pushDate: newsItem.pushDate)
			Text(newsItem.headline)
				.font(
					.custom("Oswald", size: 16)
						.weight(.regular)
				)
				.tracking(0.32)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			Text(newsItem.source ?? "")
				.font(
					.custom("Assistant", size: 12)
						.weight(.semibold)
				)
				.foregroundStyle(Color.gray)
		}
		.padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
		.sheet(isPresented: $sheetOpen) {
			VStack {
				ShareLink(item: newsItem.link!)
			}
		}
		.frame(maxWidth: .infinity)
		.background(Color.white.opacity(0.12))
		.clipShape(.rect(cornerRadius: 18))
		.scrollTransition { content, phase in
			content.scaleEffect(phase.isIdentity ? 1.0 : 0.9)
		}
		.onTapGesture {
			//			guard let url = URL(string: "https://woven.design") else {
			//				return
			//			}
			sheetOpen = true
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

struct RelativeTimeCell: View {
	let pushDate: Date?
	var relativeDate: String {
		guard let pushDate else {
			return "No Date"
		}
		if pushDate.distance(to: Date()) < 86_400 {
			return "TODAY"
		}
		return pushDate.formatted(.relative(presentation: .named))
	}
	
	var body: some View {
		if pushDate != nil {
			if relativeDate == "TODAY" {
				Text(relativeDate)
					.font(
						.custom("Oswald", size: 12)
							.weight(.semibold)
					)
					.padding(EdgeInsets(top: 1.5,
					                    leading: 6,
					                    bottom: 2,
					                    trailing: 6))
					.foregroundStyle(.navy)
					.background(.aquaBlue75)
					.clipShape(.capsule)
			} else {
				Text(relativeDate)
					.font(
						.custom("Oswald", size: 12)
							.weight(.semibold)
					)
					.foregroundStyle(.gray)
			}
		}
	}
}

// #Preview {
//	NewsListItem(newsItem: NewsItem(date: "sdf", headline: "Headline", headline_original: "sdf", source: "Reuters", link: "https://google.com", summary: "Some stuff was built", new: false))
// }
