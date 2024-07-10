//
//  NewsListItem.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 03.04.24.
//

import SwiftUI

struct NewsListItem: View {
    let newsItem: NewsItem
	@Binding var selectedNews: SelectedNews?

    var relativeDate: String {
        let pushDate = newsItem.pushDate
        guard let pushDate else {
            return "No Date"
        }

        if pushDate.distance(to: Date()) < 86400 {
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
				.environment(\._lineHeightMultiple, 0.8)

            Text(newsItem.source ?? "")
                .font(
                    .custom("Assistant", size: 12)
                        .weight(.semibold)
                )
                .opacity(0.7)
                .foregroundStyle(Color.white)
        }
		.onTapGesture {
			guard let link = newsItem.link else {
				print("No Link on the Item")
				return
			}
			if let url = URL(string: link.trimmingCharacters(in: .whitespacesAndNewlines)) {
				print("selecting news")
				selectedNews = SelectedNews(newsItem: newsItem, url: url)
			}
		}
		.listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
