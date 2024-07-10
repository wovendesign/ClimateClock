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
	struct IncomingLink {
		let title: String
		let body: String
		let url: String
	}
	
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
	
	func requestNotificationPermission() -> Bool {
		let center = UNUserNotificationCenter.current()
		
		var grantedVar = false
		center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			grantedVar = granted
		}
		return grantedVar
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		guard let notificationManager = notificationManager else {
			print("No Notification Manager attatched")
			return
		}
		print(message)
		let incomingLink = IncomingLink(title: message["title"] as? String ?? "Climate Clock",
										body: message["body"] as? String ?? "Open the Link from your Watch",
										url: message["url"] as? String ?? "https://climateclock.world")
		
		let notification: LocalNotification = LocalNotification(identifier: UUID().uuidString,
																title: incomingLink.title,
																userInfo: message,
																body: incomingLink.body,
																timeInterval: 1,
																repeats: false)
		
		Task {
			await notificationManager.schedule(localNotification: notification)
		}
	}
}
