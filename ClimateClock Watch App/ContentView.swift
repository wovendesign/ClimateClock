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
	@Environment(NetworkManager.self) var networkManager
	@Environment(LocalNotificationManager.self) var localNotificationManager
    @Environment(\.modelContext) var context
	
	@State private var path = NavigationPath()
	private var pages: [Page] = [.deadline, .lifeline, .news, .action]
	
    var body: some View {
		NavigationStack(path: $path) {
			Button {
				Task {
					await localNotificationManager.schedule(localNotification: LocalNotification(identifier: UUID().uuidString,
																								 title: "There is hope",
																								 userInfo: ["view": "newsView", "newsId": "China is building 2/3 of new wind & solar globally"],
																								 body: "China is building 2/3 of new wind & solar globally",
																								 timeInterval: 5,
																								 repeats: false))
				}
			} label: {
				Text("send notification")
			}
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
					NewsView(newsIdFromNotification: nil)
				case .lifeline:
					LifelineView()
				case .action:
					ActionView()
				case .deadline:
					DeadlineView()
				}
			}
			.navigationDestination(for: NavigationData.self) { navData in
				if (navData.view == "notificationSettings") {
					NotificationSettings()
				} else if (navData.view == "aboutView") {
					AboutView()
				} else if (navData.view == "newsView") {
					NewsView(newsIdFromNotification: navData.newsId)
				}
			}
		}
		.onAppear {
			NotificationCenter.default.addObserver(forName: Notification.Name("NavigateToView"), object: nil, queue: .main) { notification in
				print("Recieved Navigation Request to")
				if let navData = notification.object as? NavigationData {
					path.append(navData)
				}
				if let view = notification.object as? String {
					print("view \(view)")
					path.append(view)
				}
			}
			Task {
				if let data = await client.getDataFromClimateClockAPI(context: context,
																	  networkManager: networkManager) {
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
