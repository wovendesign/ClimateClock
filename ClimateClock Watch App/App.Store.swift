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
	}
	

	func fetchNewsFromAPI() async {
		do {
			let result = try await NetworkManager.shared.getClimateClockData()
			
			switch result {
			case .success(let data):
				try await saveNews(news: data.data.modules.newsfeed_1.newsfeed)
				
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
		} catch{
			print(error)
		}
	}
	
	func saveNews(news: [NewsItem]) async throws {
		let sortedNews: [NewsItem] = news.enumerated().map {
			let today: Date = Calendar.current.date(byAdding: .day, value: $0-1, to: Date()) ?? Date()
			var temp = $1
			temp.pushDate = today
			
			var todayComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: today)
			print("Scheduling notifications for \(todayComponents)")
			todayComponents.minute = (todayComponents.minute ?? 0) + 1
			print("Scheduling notifications for \(todayComponents)")
			NotificationManager.instance.scheduleNotification(headline: temp.headline, triggerTime: todayComponents)
			
			return temp
		}
		
		try await self.$news.insert(sortedNews)
	}
	
	func updateNews(oldItem: NewsItem, newItem: NewsItem) async throws {
//		try await self.$news.remove(oldItem)
		try await self.$news.insert(newItem)
	}
}
