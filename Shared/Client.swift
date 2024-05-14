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
		do {
			let result = try await NetworkManager.shared.getClimateClockData()
			
			switch result {
			case let .success(data):
				// Saving News
				let news = data.data.modules.newsfeed_1.newsfeed
				news.forEach { newsItem in
					context.insert(newsItem)
				}
				scheduleNewsNotifications(news: news)
				
				// Saving LifeLines
				context.insert(self.moduleToLifeline(module: data.data.modules._youth_anxiety,
													 type: .youth))
				context.insert(self.moduleToLifeline(module: data.data.modules.ff_divestment_stand_dot_earth,
													 type: .divestment))
				context.insert(self.moduleToLifeline(module: data.data.modules.indigenous_land_1,
													 type: .indigenous))
				context.insert(self.moduleToLifeline(module: data.data.modules.loss_damage_g20_debt, 
													 type: .g20))
				context.insert(self.moduleToLifeline(module: data.data.modules.loss_damage_g7_debt,
													 type: .g7))
				context.insert(self.moduleToLifeline(module: data.data.modules.regen_agriculture,
													 type: .agriculture))
				context.insert(self.moduleToLifeline(module: data.data.modules.renewables_1,
													 type: .renewables))
				context.insert(self.moduleToLifeline(module: data.data.modules.women_in_parliaments,
													 type: .women))
				
				
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
		}
	}
	
	func moduleToLifeline(module: LifeLineModule, type: LifeLineType) -> LifeLine {
		let order: Int = {
			switch type {
			case .renewables: return 0
			case .women: return 1
			case .divestment: return 2
			case .indigenous: return 3
			case .g7: return 4
			case .g20: return 5
			case .agriculture: return 6
			case .prolife: return 7
			default:
				return 999
			}
		}()
		
		return LifeLine(order: order,
						size: type == .renewables || type == .women ? .large : .small,
						desc: module.description,
						update_interval_seconds: module.update_interval_seconds,
						initial: module.initial,
						timestamp: module.timestamp,
						growth: module.growth,
						resolution: module.resolution,
						rate: module.rate,
						labels: module.labels,
						unit_labels: module.unit_labels)
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
		
		news.enumerated().forEach {
			let today: Date = Calendar.current.date(byAdding: .day, value: $0, to: monday) ?? Date()
			var temp = $1
			temp.pushDate = today
			
			var todayComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: today)
			todayComponents.minute = (todayComponents.minute ?? 0) + 1
			NotificationManager.instance.scheduleNotification(headline: temp.headline, triggerTime: todayComponents)
		}
	}
}
