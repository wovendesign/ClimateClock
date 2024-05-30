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

    var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					Text("Your News Notifications")
					NavigationLink {
						NotificationTimeSetter(notificationType: .first, date: $first_date)
					} label: {
						VStack {
							Text("First Notification")
							Text(DateFormat.timeHourFormat(from: first_date,
														   twentyFourHourFormat: Locale.is24HoursFormat()))
						}
					}
					.onChange(of: first_date) {
						client.updateSchedulingPreference(notificationType: .first,
														  date: first_date,
														  context: context)
					}

					//
					//				if let second_date = second_date {
					//					NavigationLink {
					//						NotificationTimeSetter(notificationType: .second)
					//					} label: {
					//						VStack {
					//							Text("Second Notification")
					//							Text("6:00 pm")
					//						}
					//					}
					//				}

					Text("We will notify you when it is time for the new News of Hope. Sometimes even twice a day.")
				}
			}
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
    }
}

#Preview {
    NotificationSettings()
}
