//
//  App.Store.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 02.04.24.
//

import Boutique
import Foundation

extension Store where Item == NewsItem {
	static let newsStore = Store<NewsItem>(
		storage: SQLiteStorageEngine.default(appendingPath: "News"),
		cacheIdentifier: \.headline
	)
}

final class NewsController: ObservableObject {
	@Stored var news: [NewsItem]
	
	init(store: Store<NewsItem>) {
		self._news = Stored(in: .newsStore)
		
		Task(priority: .medium) {
			await self.fetchNewsFromAPI()
		}
	}
	
	func fetchNewsFromAPI() async {
		do {
			let result = try await NetworkManager.shared.getClimateClockData()
			
			switch result {
			case .success(let data):
				return try await saveNews(news: data.data.modules.newsfeed_1.newsfeed)
				
			case .failure(let error):
				switch error {
				case .invalidURL:
					print("Invalid URL")
					//								alertItem = AlertContext.invalidURL
					
				case .invalidResponse:
					print("Invalid Response")
					//								alertItem = AlertContext.invalidReponse
					
				case .invalidData:
					print("Invalid Data")
					//								alertItem = AlertContext.invalidData
					
				case .unableToComplete:
					print("unableToComplete")
					//								alertItem = AlertContext.invalidToComplete
				}
			}
		} catch {
			print(error)
		}
	}
	
	func saveNews(news: [NewsItem]) async throws {
		// Get the current calendar and today's date
		let calendar = Calendar.current
		let today = Date()

		// Get the start of the current week
		var startOfWeek = Date()
		var interval = TimeInterval(0)
		_ = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: today)

		// Get the components of the start of the week
		let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek)

		// Get the date of Monday in the current week
		guard let monday = calendar.date(from: components) else {
			print("Failed to get Monday of the current week")
			return
		}
		
		let sortedNews: [NewsItem] = news.enumerated().map {
			let today: Date = Calendar.current.date(byAdding: .day, value: $0, to: monday) ?? Date()
			var temp = $1
			temp.pushDate = today
			
			var todayComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: today)
			todayComponents.minute = (todayComponents.minute ?? 0) + 1
			NotificationManager.instance.scheduleNotification(headline: temp.headline, triggerTime: todayComponents)
			
			return temp
		}
		
		return try await self.$news.insert(sortedNews)
	}
	
	func updateNews(oldItem: NewsItem, newItem: NewsItem) async throws {
//		try await self.$news.remove(oldItem)
		try await $news.insert(newItem)
	}
}
