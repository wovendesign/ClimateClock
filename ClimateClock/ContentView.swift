//
//  ContentView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
import UserNotifications

enum SheetContent {
	case Onboarding, ActionClock
}

struct ContentView: View {
	@Environment(\.openURL) var openURL
	@Environment(WatchConnector.self) var watchConnector
	@Environment(LocalNotificationManager.self) var lnManager
	
	@State private var sheetOpen = true
	@State private var sheetContent: SheetContent = .Onboarding
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					
					Button {
						watchConnector.requestNotificationPermission()
					} label: {
						Text("Get Notified")
					}
					.buttonStyle(.bordered)
					
					HomeBlob(headerForegroundColor: .black,
							 headerBackgroundColor: .black,
							 headerImage: "heart",
							 headerText: nil,
							 headline: "Open your Apple Watch and start exploring our app.",
							 description: nil,
							 buttonText: "View Tour Again",
							 buttonImage: "chevron.right",
							 buttonColor: .navy75,
							 foregroundColor: .black,
							 backgroundColor: Color(red: 0.56, green: 0.76, blue: 1))
					.onTapGesture {
						sheetOpen = true
						sheetContent = .Onboarding
					}
					
					HomeBlob(headerForegroundColor: .black,
							 headerBackgroundColor: .red.opacity(0.2),
							 headerImage: "heart",
							 headerText: "#ActInTime",
							 headline: "View the Action Clock",
							 description: "Quickly access the Deadline and Lifelines.",
							 buttonText: "Open Website",
							 buttonImage: "arrow.up.forward",
							 buttonColor: .red,
							 foregroundColor: .black,
							 backgroundColor: .white)
					.onTapGesture {
						sheetOpen = true
						sheetContent = .ActionClock
					}
					
					HomeBlob(headerForegroundColor: .black,
							 headerBackgroundColor: .white.opacity(0.4),
							 headerImage: "heart",
							 headerText: "STAY INFORMED",
							 headline: "Subscribe to the Climate Clock Newsletter",
							 description: "Join the mailing list for exclusive updates from the Climate Clock and be among the first to know about new clock installations and opportunities for engagement with our global network of changemakers!",
							 buttonText: "Join the Newsletter",
							 buttonImage: "chevron.right",
							 buttonColor: .aquaBlue,
							 foregroundColor: .white,
							 backgroundColor: Color(red: 0.11, green: 0.11, blue: 0.12))
					.onTapGesture {
						openURL(URL(string: "https://actionnetwork.org/forms/join-our-community-6?source=direct_link")!)
					}
				}
				.padding()
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					HStack() {
						Image("climateclock-logo")
						Text("Climate Clock for Apple Watch")
							.font(Font.custom("Oswald", size: 20))
							.fontWeight(.semibold)
							.foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
					}
					.minimumScaleFactor(0.5)
				}
			}
			.onAppear {
				watchConnector.notificationManager = lnManager
			}
			.sheet(isPresented: $sheetOpen) {
				switch sheetContent {
				case .Onboarding:
					Onboarding(sheetOpen: $sheetOpen)
						.presentationDragIndicator(.visible)
				case .ActionClock:
					NavigationStack {
						WebView(url: URL(string: "https://digital.cclock.org")!)
							.ignoresSafeArea()
							.navigationTitle("Action Clock")
							.navigationBarTitleDisplayMode(.inline)
					}
				}
			}
		}
	}
}
//
//#Preview {
//    ContentView()
//}
