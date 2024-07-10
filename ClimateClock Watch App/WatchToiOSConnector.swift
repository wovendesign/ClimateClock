//
//  WatchToiOSConnector.swift
//  ClimateClock
//
//  Created by Eric Wätke on 09.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation
import WatchConnectivity

@Observable
class WatchToiOSConnector: NSObject, WCSessionDelegate {
	var session: WCSession
	
	init(session: WCSession = .default) {
		self.session = session
		super.init()
		session.delegate = self
		session.activate()
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
		
	}
	
	func sendUrlToiOS(title: String, body: String, url: String) {
		if (!session.isReachable) {
			print("iphone isnt reachable")
		}
		
		session.sendMessage(["title": title, "body": body, "url": url], replyHandler: nil)
	}
}
