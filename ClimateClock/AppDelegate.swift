//
//  AppDelegate.swift
//  ClimateClock
//
//  Created by Eric Wätke on 09.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	// Other app delegate methods

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		UNUserNotificationCenter.current().delegate = self
		// Request notification permission here if needed
		return true
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let watchConnector = WatchConnector()
		watchConnector.handleNotificationResponse(response: response)
		completionHandler()
	}
}

