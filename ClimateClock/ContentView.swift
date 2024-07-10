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
			ScrollView {
				VStack {
					HStack(alignment: .center) {
						Spacer()
						Image("climateclock-logo")
						Text("Climate Clock")
						  .font(Font.custom("Oswald", size: 20))
						  .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
						Spacer()
					}
					Button {
						watchConnector.requestNotificationPermission()
					} label: {
						Text("Get Notified")
					}
					.buttonStyle(.bordered)
				}
			}
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
