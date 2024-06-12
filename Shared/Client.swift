//
//  Client.swift
//  ClimateClock
//
//  Created by Eric Wätke on 14.05.24.
//

import Foundation
import Observation
import SwiftData
import UserNotifications

@Observable public final class Client {
	
	var notificationPermissionGranted: Bool = false
	
	func checkNotificationPermission() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			if settings.authorizationStatus == .authorized {
				self.notificationPermissionGranted = true
			}
		}
	}
	
	func getNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				completion(settings.authorizationStatus)
			}
		}
	}

	
	func requestNotificationPermissions() {
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
			if (success) {
				self.notificationPermissionGranted = true
			} else if let error = error {
				self.notificationPermissionGranted = false
				print(error.localizedDescription)
			}
		}
	}

	func scheduleNotification(news: NewsItem, triggerTime: DateComponents) {
		let content = UNMutableNotificationContent()
		content.title = "New hope is coming"
		content.subtitle = news.headline

		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)

		let request = UNNotificationRequest(identifier: news.headline,
											content: content,
											trigger: trigger)

		UNUserNotificationCenter.current().add(request)
	}
	
	func getDataFromClimateClockAPI(context: ModelContext) async {
		do {
			let result = try await NetworkManager.shared.getClimateClockData()
			
			switch result {
			case let .success(data):
				// Saving News
				saveNewsNotifications(news: data.data.modules.newsfeed_1.newsfeed,
									  context: context)
				
				// Saving LifeLines
				context.insert(moduleToLifeline(module: data.data.modules._youth_anxiety,
												type: .youth))
				context.insert(moduleToLifeline(module: data.data.modules.ff_divestment_stand_dot_earth,
												type: .divestment))
				context.insert(moduleToLifeline(module: data.data.modules.indigenous_land_1,
												type: .indigenous))
				context.insert(moduleToLifeline(module: data.data.modules.loss_damage_g20_debt,
												type: .g20))
				context.insert(moduleToLifeline(module: data.data.modules.loss_damage_g7_debt,
												type: .g7))
				context.insert(moduleToLifeline(module: data.data.modules.regen_agriculture,
												type: .agriculture))
				context.insert(moduleToLifeline(module: data.data.modules.renewables_1,
												type: .renewables))
				context.insert(moduleToLifeline(module: data.data.modules.women_in_parliaments,
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
	
	func saveNewsNotifications(news: [NewsItem], context: ModelContext) {
		//		try! context.delete(model: NewsItem.self)
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
		
		var currentSlot: NotificationType = .first
		for (index, newsItem) in news.enumerated() {
			if (index > 7) {
				currentSlot = .second
			}
			
			let today: Date = Calendar.current.date(byAdding: .day, value: index % 7, to: monday) ?? Date()
			let temp = newsItem
			temp.pushDate = today
			temp.scheduled = currentSlot
			
			scheduleNewsNotifications(news: temp, context: context)
			context.insert(temp)
		}
	}
	
	func scheduleNewsNotifications(news: NewsItem, context: ModelContext) {
		guard let pushDate = news.pushDate else {
			print("News didnt have a push date")
			return
		}
		
		guard let scheduled = news.scheduled else {
			print("News isn’t scheduled yet")
			return
		}
		
		var scheduleDateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: pushDate)
		
		let schedulingPreference = getSchedulingPreference(notificationType: scheduled)
		
		scheduleDateComponents.hour = schedulingPreference.hour
		scheduleDateComponents.minute = schedulingPreference.minute
		
//		print("Scheduled \(news.headline) for \(scheduleDateComponents)")
		
		scheduleNotification(news: news, triggerTime: scheduleDateComponents)
	}
	
	struct SchedulingPreference {
		let hour: Int
		let minute: Int
	}
	
	func setDefaultSchedulingPreferences() {
		UserDefaults.standard.set(8, forKey: "first_notification_hour")
		UserDefaults.standard.set(0, forKey: "first_notification_minute")
		
		UserDefaults.standard.set(18, forKey: "second_notification_hour")
		UserDefaults.standard.set(0, forKey: "second_notification_minute")
	}
	
	func getSchedulingPreference(notificationType: NotificationType) -> SchedulingPreference {
		switch notificationType {
		case .first:
			return SchedulingPreference(hour: UserDefaults.standard.integer(forKey: "first_notification_hour"),
										minute: UserDefaults.standard.integer(forKey: "first_notification_minute"))
		case .second:
			return SchedulingPreference(hour: UserDefaults.standard.integer(forKey: "second_notification_hour"),
										minute: UserDefaults.standard.integer(forKey: "second_notification_minute"))
		}
	}
	
	func updateSchedulingPreference(notificationType: NotificationType, date: Date, context: ModelContext) {
		let components = Calendar.current.dateComponents([.hour, .minute], from: date)
		
		switch notificationType {
		case .first:
			UserDefaults.standard.set(components.hour, forKey: "first_notification_hour")
			UserDefaults.standard.set(components.minute, forKey: "first_notification_minute")
		case .second:
			UserDefaults.standard.set(components.hour, forKey: "second_notification_hour")
			UserDefaults.standard.set(components.minute, forKey: "second_notification_minute")
			
		}
		
		
		let now = Date.now
		let predicate = #Predicate<NewsItem> { news in
			if let date = news.pushDate {
				return date >= now
			} else {
				return false
			}
		}
		let fetchDescriptor = FetchDescriptor<NewsItem>(predicate: predicate)
		
		do {
			let newsItems = try context.fetch(fetchDescriptor)
			
			newsItems.forEach { newsItem in
				scheduleNewsNotifications(news: newsItem, context: context)
			}
		} catch {
			print("Failed to load News: ", error)
		}
	}
}
