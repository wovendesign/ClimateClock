//
//  NotificationSettings.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 29.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftData
import SwiftUI

enum DateFormat {
	// Change time from 12 hour to 24 hour format
	static func timeHourFormat(from date: Date, twentyFourHourFormat: Bool) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = twentyFourHourFormat ? "HH:mm" : "hh:mm"
		return dateFormatter.string(from: date)
	}
}

struct NotificationSettings: View {
	@Environment(Client.self) var client
	@Environment(\.modelContext) var context
	
	@State var first_date: Date
	@State var second_date: Date
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					Text("Your News Notifications")
						.font(
							.custom("Assistant", size: 13)
								.weight(.semibold)
						)
					
					if (!client.notificationPermissionGranted) {
						Button {
							client.requestNotificationPermissions()
						} label: {
							Text("Allow Notifications")
						}

					} else {
						NotificationSettingButton(date: $first_date,
												  notificationType: .first) {
							client.updateSchedulingPreference(notificationType: .first,
															  date: first_date,
															  context: context)
						}
						NotificationSettingButton(date: $second_date,
												  notificationType: .second) {
							client.updateSchedulingPreference(notificationType: .second,
															  date: second_date,
															  context: context)
						}
					}
					
					HighlightedText(
						text: "We will notify you when it is time for the new News of Hope. Sometimes even twice a day.",
						highlighted: "News of Hope",
						highlightColor: .white)
					.foregroundStyle(.gray)
					.font(
						.custom("Assistant", size: 12)
							.weight(.semibold)
					)
						
				}
				.padding()
			}
			.foregroundStyle(.white)
			.navigationTitle("News of Hope")
		}
	}
	
	init() {
		let first_hour = UserDefaults.standard.integer(forKey: "first_notification_hour")
		let first_minute = UserDefaults.standard.integer(forKey: "first_notification_minute")
		var components = DateComponents()
		components.hour = first_hour
		components.minute = first_minute
		first_date = Calendar.current.date(from: components) ?? Date.now
		
		let second_hour = UserDefaults.standard.integer(forKey: "second_notification_hour")
		let second_minute = UserDefaults.standard.integer(forKey: "second_notification_minute")
		components.hour = second_hour
		components.minute = second_minute
		second_date = Calendar.current.date(from: components) ?? Date.now
	}
}

#Preview {
	NotificationSettings()
}

struct NotificationSettingButton: View {
	@Binding var date: Date
	let notificationType: NotificationType
	let action: () -> Void
	
	var body: some View {
		NavigationLink {
			NotificationTimeSetter(date: $date)
		} label: {
			VStack(alignment: .leading) {
				Text(notificationType == .first ? "First Notification" : "Second Notification")
					.fontWeight(.light)
					.lineLimit(1)
					.minimumScaleFactor(0.5)
				Text(DateFormat.timeHourFormat(from: date,
											   twentyFourHourFormat: Locale.is24HoursFormat()))
					.fontWeight(.medium)
			}
			.containerRelativeFrame(.horizontal)
		}
		.onChange(of: date, action)
		.buttonBorderShape(.roundedRectangle(radius: 11))
	}
}
