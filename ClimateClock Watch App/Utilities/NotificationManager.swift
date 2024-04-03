//
//  NotificationManager.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.04.24.
//

import Foundation
import UserNotifications

class NotificationManager {
	static let instance = NotificationManager()
	
	func requestAuthorization() {
		let options: UNAuthorizationOptions = [.alert, .badge, .provisional]
		UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
			if let error = error {
				print(error)
			} else {
				print("successfully requested permission")
			}
		}
	}
	
	func scheduleNotification(headline: String, triggerTime: DateComponents) {
		let content = UNMutableNotificationContent()
		content.title = "New hope is coming"
		content.subtitle = headline
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
		
		let request = UNNotificationRequest(identifier: UUID().uuidString,
											content: content,
											trigger: trigger)
		
		UNUserNotificationCenter.current().add(request)
	}
}
