//
//  Client.swift
//  ClimateClock
//
//  Created by Eric Wätke on 14.05.24.
//

import Foundation
import Observation
import SwiftData

@Observable public final class Client {
	func fetchNewsFromAPI() async -> [NewsItem]? {
		do {
			let result = try await NetworkManager.shared.getClimateClockData()
			
			switch result {
			case let .success(data):
				return data.data.modules.newsfeed_1.newsfeed
				
			case let .failure(error):
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
			return nil
		}
		return nil
	}
	
	func getDataFromClimateClockAPI(context: ModelContext) async {
		if let news = await fetchNewsFromAPI() {
			news.forEach { newsItem in
				context.insert(newsItem)
			}
			scheduleNewsNotifications(news: news)
		}
	}
	
	func scheduleNewsNotifications(news: [NewsItem]) {
//		Get the current calendar and today's date
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
	}
}
