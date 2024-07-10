//
//  SheetButtonGroup.swift
//  ClimateClock
//
//  Created by Eric Wätke on 07.07.24.
//  Copyright © 2024 woven. All rights reserved.
//
import AuthenticationServices
import SwiftUI

struct SheetButtonGroup: View {
	@Environment(WatchToiOSConnector.self) var watchConnector: WatchToiOSConnector
	let notificationTitle: String
	let notificationBody: String
	let url: URL
	
	var body: some View {
		Button {
			// Source: https://www.reddit.com/r/apple/comments/rcn2h7/comment/hnwr8do/
			let session = ASWebAuthenticationSession(
				url: url,
				callbackURLScheme: nil
			) { _, _ in
			}
			
			// Makes the "Watch App Wants To Use example.com to Sign In" popup not show up
			session.prefersEphemeralWebBrowserSession = true
			
			session.start()
		} label: {
			Text("Read on Watch")
				.applyTextStyle(.Label_Button)
		}
		
		Button {
			watchConnector.sendUrlToiOS(title: notificationTitle,
										body: notificationBody,
										url: url.absoluteString)
		} label: {
			Text("Open on phone")
				.applyTextStyle(.Label_Button)
		}
		
		ShareLink(item: url) {
			Label {
				Text("Share")
					.applyTextStyle(.Label_Button)
			} icon: {
				Image(systemName: "square.and.arrow.up")
			}
		}
	}
}
