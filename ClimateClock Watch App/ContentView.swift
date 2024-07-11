//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Charts
import SwiftUI

enum Page {
	case lifeline, news, action, deadline
}

struct ContentView: View {
    @Environment(Client.self) var client
	@Environment(LocalNotificationManager.self) var localNotificationManager
    @Environment(\.modelContext) var context
	
	@State private var path = NavigationPath()
	private var pages: [Page] = [.deadline, .lifeline, .news, .action]
	
    var body: some View {
		NavigationStack(path: $path) {
			List(pages, id:  \.self) { page in
				NavigationLinkItem(page: page)
			}
			.listStyle(.carousel)
			.navigationTitle("Climate Clock")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					NavigationLink(value: "aboutView") {
						Image("climate_icon")
							.resizable()
							.frame(width: 16, height: 16)
					}
				}
			}
			.navigationDestination(for: Page.self) { page in
				switch (page) {
				case .news:
					NewsView()
				case .lifeline:
					LifelineView()
				case .action:
					ActionView()
				case .deadline:
					DeadlineView()
				}
			}
			.navigationDestination(for: String.self) { textValue in
				if (textValue == "notificationSettings") {
					NotificationSettings()
				} else if (textValue == "aboutView") {
					AboutView()
				}
			}
		}
		.onAppear {
			Task {
				if let data = await client.getDataFromClimateClockAPI(context: context) {
					await localNotificationManager.saveNewsNotifications(news: data, context: context)
				}
				
				await localNotificationManager.getPendingRequests()
			}
		}
    }
}

#Preview {
    ContentView()
}
