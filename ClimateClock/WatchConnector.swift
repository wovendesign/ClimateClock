//
//  WatchConnector.swift
//  ClimateClock
//
//  Created by Eric Wätke on 09.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation
import WatchConnectivity
import UIKit
import UserNotifications

@Observable
class WatchConnector: NSObject, WCSessionDelegate {
	var session: WCSession
	var notificationManager: LocalNotificationManager?
	
	init(session: WCSession = .default) {
		self.session = session
		self.notificationManager = nil
		super.init()
		session.delegate = self
		session.activate()
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
	func requestNotificationPermission() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			print(granted)
			print(error)
		}
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		guard let notificationManager = notificationManager else {
			print("No Notification Manager attatched")
			return
		}
		print(message)
		let url = message["url"] as? String ?? "https://woven.design"
		let notification: LocalNotification = LocalNotification(identifier: url,
																title: "Read News of Hope",
																userInfo: message,
																body: url,
																timeInterval: 1,
																repeats: false)
		
		Task {
			await notificationManager.schedule(localNotification: notification)
		}
	}
}
