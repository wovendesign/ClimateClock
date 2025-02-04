//
//  NotificationSettings.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 29.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftData
import UserNotifications
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
	@Environment(LocalNotificationManager.self) var localNotificationManager
    @Environment(\.modelContext) var context

    @State var first_date: Date
    @State var second_date: Date

    @State private var settingsAlert: Bool = false

    var body: some View {
            List {
                Section {
                    if !localNotificationManager.notificationPermissionGranted {
                        Button {
							localNotificationManager.getNotificationPermission { status in
                                switch status {
                                case .denied:
                                    settingsAlert = true
                                default:
									Task {
										try await localNotificationManager.requestAuthorization()
									}
                                }
                            }
                        } label: {
                            Text("Allow Notifications")
                        }
                        .foregroundStyle(.black)
                        .listRowBackground(RoundedRectangle(cornerRadius: 11)
                            .foregroundStyle(.lime))
                        .alert("Notifications Disabled", isPresented: $settingsAlert) {
                            Text("To enable Notifications, go to your Phone Settings > Notifications > Climate Clock and enable 'Allow Notifications'.")
                            Button {
                                settingsAlert = false
                            } label: {
                                Text("OK")
                            }
                        }

                    } else {
                        NotificationSettingButton(date: $first_date,
                                                  notificationType: .first)
                        {
							Task {
								await localNotificationManager.updateSchedulingPreference(notificationType: .first,
																  date: first_date,
																  context: context)
							}
                        }
                        NotificationSettingButton(date: $second_date,
                                                  notificationType: .second)
                        {
							Task {
								await localNotificationManager.updateSchedulingPreference(notificationType: .second,
																  date: second_date,
																  context: context)
							}
                        }
                    }
                } header: {
                    Text("Your News Notifications")
                        .font(
                            .custom("Assistant", size: 13)
                                .weight(.semibold)
                        )
                } footer: {
                    HighlightedText(
                        text: "We will notify you when it is time for the new News of Hope. Sometimes even twice a day.",
                        highlighted: "News of Hope",
                        highlightColor: .white
                    )
                    .foregroundStyle(.gray)
                    .font(
                        .custom("Assistant", size: 12)
                            .weight(.semibold)
                    )
                }
				
				Section {
					ForEach(localNotificationManager.pendingRequests, id: \.identifier) { request in
						VStack(alignment: .leading) {
							if let trigger: UNNotificationTrigger = request.trigger {
								Text(trigger.debugDescription)
							}
							
							HStack {
								Text(request.identifier)
									.font(.caption)
									.foregroundStyle(.secondary)
							}
						}
					}
				} header: {
					Text("Upcoming Notifications")
				}
            }
            .foregroundStyle(.white)
            .navigationTitle("News of Hope")
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
        NavigationLink(destination: NotificationTimeSetter(date: $date)) {
            VStack(alignment: .leading) {
                Text(notificationType == .first ? "First Notification" : "Second Notification")
                    .fontWeight(.light)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Text(DateFormat.timeHourFormat(from: date,
                                               twentyFourHourFormat: Locale.is24HoursFormat()))
                    .fontWeight(.medium)
            }
        }
        .onChange(of: date, action)
    }
}
