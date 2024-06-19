//
//  NewsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//
import AuthenticationServices
import SwiftData
import SwiftUI
import WatchKit

struct NewsView: View {
	static var now: Date { Date.now }
	
	@Query(filter: #Predicate<NewsItem> { $0.pushDate ?? now < now },
		   sort: \NewsItem.pushDate,
		   order: .reverse)
	var news: [NewsItem]
	
	@Environment(Client.self) var client: Client
	@State private var isShowingSheet = false
	
	var body: some View {
			TabTitleLayout(
				headline: "Newsfeed of Hope",
				subtitle: "Daily news of recent climate victories."
			) {
				LazyVStack {
					ForEach(news, id: \.id) { item in
						NewsListItem(newsItem: item)
					}
				}
				.contentMargins(.vertical, 8, for: .scrollContent)
			}
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					ToolbarButton(isShowingSheet: $isShowingSheet)
				}
			}
		
		.onAppear {
			client.checkNotificationPermission()
		}
	}
}
