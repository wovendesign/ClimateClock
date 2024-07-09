//
//  ContentView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
	@Environment(WatchConnector.self) var watchConnector
	@Environment(LocalNotificationManager.self) var lnManager
	
    var body: some View {
		NavigationStack {
			VStack {
				Text("Climate Clock")
				Button {
					watchConnector.requestNotificationPermission()
				} label: {
					Text("Get Notified")
				}
				.buttonStyle(.bordered)

			}
			.navigationTitle("Climate Clock")
			.onAppear {
				watchConnector.notificationManager = lnManager
			}
		}
    }
}
//
//#Preview {
//    ContentView()
//}
