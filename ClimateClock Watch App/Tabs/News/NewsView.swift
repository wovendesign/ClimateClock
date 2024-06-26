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
	@Environment(LocalNotificationManager.self) var localNotificationManager: LocalNotificationManager
	@State private var isShowingSheet = false
	
	var body: some View {
		List(news) { item in
			NewsListItem(newsItem: item)
		}
		.padding(.horizontal, 4)
		.containerBackground(.navy75.gradient, for: .navigation)
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				NavigationLink(value: "notificationSettings") {
					Image(systemName: localNotificationManager.notificationPermissionGranted ? "bell.badge.fill" : "bell.slash.fill")
									.foregroundStyle(.white)
				}
			}
		}
		.onAppear {
			Task {
				await localNotificationManager.getCurrentSettings()
			}
		}
	}
}
