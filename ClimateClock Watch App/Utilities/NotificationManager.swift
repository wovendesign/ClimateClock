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

//    func requestAuthorization() -> Bool {
//        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
//			if (success) {
//				return true
//			} else if let error = error {
//				print(error.localizedDescription)
//			}
//			return false
//        }
//    }
//
//    func scheduleNotification(news: NewsItem, triggerTime: DateComponents) {
//        let content = UNMutableNotificationContent()
//        content.title = "New hope is coming"
//        content.subtitle = news.headline
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
//
//        let request = UNNotificationRequest(identifier: news.headline,
//                                            content: content,
//                                            trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
//    }
}
