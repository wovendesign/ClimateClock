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

@Observable
class WatchConnector: NSObject, WCSessionDelegate {
	var session: WCSession
	
	init(session: WCSession = .default) {
		self.session = session
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
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		print(message)
		let url = message["url"] as? String ?? "https://woven.design"
//		let url = message["url"] as? String ?? "https://climateclock.world"
		
		if let url = URL(string: url) {
			UIApplication.shared.open(url)
		}
	}
}
//14:22
