//
//  NotificationManager.swift
//  ClimateClock
//
//  Created by Eric Wätke on 26.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftData

@Observable
public final class LocalNotificationManager: NSObject {
	var notificationPermissionGranted: Bool = false
	var pendingRequests: [UNNotificationRequest] = []
	
	public override init() {
		super.init()
		UNUserNotificationCenter.current().delegate = self
	}

	func getNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				completion(settings.authorizationStatus)
			}
		}
	}
	
	func getCurrentSettings() async {
		let currentSettings = await UNUserNotificationCenter.current().notificationSettings()
		notificationPermissionGranted = (currentSettings.authorizationStatus == .authorized)
	}

	func requestAuthorization() async throws {
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		try await UNUserNotificationCenter.current().requestAuthorization(options: options)
	}
	
	func schedule(localNotification: LocalNotification) async {
		let content = UNMutableNotificationContent()

		content.title = localNotification.title
		content.body = localNotification.body
		content.sound = .default
		
		if localNotification.scheduleType == .time {
			guard let timeInterval = localNotification.timeInterval else { return }
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: localNotification.repeats)
			
			let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
			try? await UNUserNotificationCenter.current().add(request)
		} else {
			guard let dateComponents = localNotification.dateComponents else { return }
			let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
			
			let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
			try? await UNUserNotificationCenter.current().add(request)
		}
		
		
		await getPendingRequests()
	}
	
	func getPendingRequests() async {
		pendingRequests = await UNUserNotificationCenter.current().pendingNotificationRequests()
	}
	
	func removeRequest(withIdentifier identifier: String) {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
		if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
			pendingRequests.remove(at: index)
		}
	}
	
	func saveNewsNotifications(news: [NewsItem], context: ModelContext) async {
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
			if index > 7 {
				currentSlot = .second
			}

			let today: Date = Calendar.current.date(byAdding: .day, value: index % 7, to: monday) ?? Date()
			let temp = newsItem
			temp.pushDate = today
			temp.scheduled = currentSlot

			await scheduleNewsNotifications(news: temp)
			context.insert(temp)
		}
	}

	func scheduleNewsNotifications(news: NewsItem) async {
		guard let pushDate = news.pushDate else {
			print("News didnt have a push date")
			return
		}

		guard let scheduled = news.scheduled else {
			print("News isn’t scheduled yet")
			return
		}

		var scheduleDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: pushDate)

		let schedulingPreference = getSchedulingPreference(notificationType: scheduled)

		scheduleDateComponents.hour = schedulingPreference.hour
		scheduleDateComponents.minute = schedulingPreference.minute
		
		let notification = LocalNotification(identifier: news.headline,
											 title: "There is hope!",
											 body: news.headline,
											 dateComponents: scheduleDateComponents,
											 repeats: false)

		//		print("Scheduled \(news.headline) for \(scheduleDateComponents)")

//        scheduleNotification(news: news, triggerTime: scheduleDateComponents)
		await schedule(localNotification: notification)
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

	func updateSchedulingPreference(notificationType: NotificationType, date: Date, context: ModelContext) async {
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

			for newsItem in newsItems {
				await scheduleNewsNotifications(news: newsItem)
			}
		} catch {
			print("Failed to load News: ", error)
		}
	}
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
	// Delegate
	public func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
		await getPendingRequests()
		return [.badge]
	}
}
