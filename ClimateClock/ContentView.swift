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
	@Environment(\.scenePhase) var scenePhase
	@Environment(WatchConnector.self) var watchConnector
	@Environment(LocalNotificationManager.self) var lnManager
	
	@State private var sheetOpen = true
	@State private var sheetContent: SheetContent = .Onboarding
	@State private var showingAlert = false
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					if (!lnManager.isGranted) {
						Button {
							if (!watchConnector.requestNotificationPermission()) {
								print("Direct to Settings")
								showingAlert = true
							}
						} label: {
							VStack {
								VStack {
									Text("Do you want to read articles & visit links on your phone?")
										.font(.custom("Oswald", size: 26).weight(.medium))
										.multilineTextAlignment(.leading)
										.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
									
									Text("Allow notifications to be send from your Apple Watch to your phone to read articles and visit links from the Climate Clock app directly on your phone.")
									  .font(.custom("Assistant", size: 17))
									  .multilineTextAlignment(.leading)
									  .foregroundColor(.white)
									  .frame(maxWidth: .infinity, alignment: .topLeading)
									  .opacity(0.7)
								}
								Text("Allow Notifications")
								  .font(
									.custom("Oswald", size: 18)
									  .weight(.semibold)
								  )
								  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
								  .padding(.top, 12)
								  .padding(.bottom, 14)
								  .foregroundStyle(Color(red: 0.03, green: 0.19, blue: 0.31))
								  .background(Color(red: 0.85, green: 0.89, blue: 0.2))
								  .clipShape(.rect(cornerRadius: 12))
							}
							.padding(.horizontal, 32)
							.padding(.top, 24)
							.padding(.bottom, 28)
							.background(Color(red: 0.11, green: 0.11, blue: 0.12))
							.foregroundStyle(.white)
							.clipShape(.rect(cornerRadius: 24))
							.overlay(
								RoundedRectangle(cornerRadius: 24)
									.inset(by: 0.5)
									.stroke(.white.opacity(0.25), lineWidth: 1)

							)
						}
					}
					
					HomeBlob(headerForegroundColor: .black,
							 headerBackgroundColor: .black,
							 headerImage: nil,
							 headerText: nil,
							 headline: "Open your Apple Watch and start exploring our app.",
							 description: nil,
							 buttonText: "View Tour Again",
							 buttonImage: "arrow-tour",
							 buttonColor: Color(red: 0.03, green: 0.19, blue: 0.31),
							 foregroundColor: .black,
							 backgroundColor: Color(red: 0.56, green: 0.76, blue: 1))
					.onTapGesture {
						sheetOpen = true
						sheetContent = .Onboarding
					}
					
					HomeBlob(headerForegroundColor: .black,
							 headerBackgroundColor: .red.opacity(0.2),
							 headerImage: "MEGAPHONE",
							 headerText: "#ActInTime",
							 headline: "View the Action Clock",
							 description: "Quickly access the Deadline and Lifelines.",
							 buttonText: "Open Website",
							 buttonImage: "arrow-clock",
							 buttonColor: .red,
							 foregroundColor: .black,
							 backgroundColor: .white)
					.onTapGesture {
						sheetOpen = true
						sheetContent = .ActionClock
					}
					
					HomeBlob(headerForegroundColor: .black,
							 headerBackgroundColor: .white.opacity(0.4),
							 headerImage: "NEWS",
							 headerText: "STAY INFORMED",
							 headline: "Subscribe to the Climate Clock Newsletter",
							 description: "Join the mailing list for exclusive updates from the Climate Clock and be among the first to know about new clock installations and opportunities for engagement with our global network of changemakers!",
							 buttonText: "Join the Newsletter",
							 buttonImage: "arrow-newsletter",
							 buttonColor: Color(red: 0.56, green: 0.76, blue: 1),
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
							.resizable()
							.frame(width: 40, height: 40)
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
			.onChange(of: scenePhase) {
				Task {
					await lnManager.getCurrentSettings()
				}
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
							.presentationDragIndicator(.visible)
							.toolbar {
								ToolbarItem(placement: .topBarLeading) {
									HStack() {
										Text("Action Clock")
											.font(Font.custom("Oswald", size: 20))
											.fontWeight(.semibold)
											.foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
									}
									.minimumScaleFactor(0.5)
								}
								ToolbarItem(placement: .topBarTrailing) {
									Button {
										sheetOpen = false
									} label: {
										Text("Close")
                                            .font(.custom("Oswald", size: 18).weight(.semibold))
                                            .foregroundStyle(.red)
									}
								}
							}
					}
				}
			}
			.alert(isPresented: $showingAlert) {
				Alert(
					title: Text("Allow Notifications for the Climate Clock"),
					message: Text("Please go to Settings and turn on the permissions"),
					primaryButton: .cancel(Text("Cancel")),
					secondaryButton: .default(Text("Settings"), action: {
					  if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
						UIApplication.shared.open(url, options: [:], completionHandler: nil)
					  }
					})
				)
			}
		}
	}
}
//
//#Preview {
//    ContentView()
//}
