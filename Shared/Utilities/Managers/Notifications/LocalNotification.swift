//
//  LocalNotification.swift
//  ClimateClock
//
//  Created by Eric Wätke on 26.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation

struct LocalNotification {
	internal init(identifier: String,
				  categoryIdentifier: String? = nil,
				  title: String,
				  subtitle: String? = nil,
				  bundleImageName: String? = nil,
				  userInfo: [AnyHashable : Any]? = nil,
				  body: String,
				  timeInterval: Double,
				  repeats: Bool) {
		self.identifier = identifier
		self.categoryIdentifier = categoryIdentifier
		self.scheduleType = .time
		self.title = title
		self.subtitle = subtitle
		self.bundleImageName = bundleImageName
		self.userInfo = userInfo
		self.body = body
		self.timeInterval = timeInterval
		self.dateComponents = nil
		self.repeats = repeats
		
	}
	
	internal init(identifier: String,
				  categoryIdentifier: String? = nil,
				  title: String,
				  subtitle: String? = nil,
				  bundleImageName: String? = nil,
				  userInfo: [AnyHashable : Any]? = nil,
				  body: String,
				  dateComponents: DateComponents,
				  repeats: Bool) {
		self.identifier = identifier
		self.categoryIdentifier = categoryIdentifier
		self.scheduleType = .calendar
		self.title = title
		self.bundleImageName = bundleImageName
		self.userInfo = userInfo
		self.subtitle = subtitle
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
	var subtitle: String?
	var bundleImageName: String?
	var userInfo: [AnyHashable : Any]?
	var timeInterval: Double?
	var dateComponents: DateComponents?
	var repeats: Bool
	var categoryIdentifier: String?
}
