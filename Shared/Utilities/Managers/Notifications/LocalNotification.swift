//
//  LocalNotification.swift
//  ClimateClock
//
//  Created by Eric Wätke on 26.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation

struct LocalNotification {
	init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
		self.identifier = identifier
		self.scheduleType = .time
		self.title = title
		self.body = body
		self.timeInterval = timeInterval
		self.dateComponents = nil
		self.repeats = repeats
	}
	
	init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
		self.identifier = identifier
		self.scheduleType = .calendar
		self.title = title
		self.body = body
		self.timeInterval = nil
		self.dateComponents = dateComponents
		self.repeats = repeats
	}
	
	enum ScheduleType {
		case time, calendar
	}
	
	var identifier: String
	var scheduleType: ScheduleType
	var title: String
	var body: String
	
//	var userInfo: [AnyHashable : Any]
	
	var timeInterval: Double?
	
	var dateComponents: DateComponents?
	
	var repeats: Bool
}
