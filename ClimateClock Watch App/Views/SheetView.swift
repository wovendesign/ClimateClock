//
//  SheetView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 19.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import AuthenticationServices
import SwiftUI

struct SheetView<Content: View>: View {
	let url: URL?
	let content: Content?
	
    var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				content

				if let url = url {
					let _ = print(url)
					Button("Read on watch") {
						// Source: https://www.reddit.com/r/apple/comments/rcn2h7/comment/hnwr8do/
						let session = ASWebAuthenticationSession(
							url: url,
							callbackURLScheme: nil
						) { _, _ in
						}

						// Makes the "Watch App Wants To Use example.com to Sign In" popup not show up
						session.prefersEphemeralWebBrowserSession = true

						session.start()
					}
					
					Button {
						
					} label: {
						Text("Open on phone (coming soon)")
					}
					.disabled(true)
					.opacity(0.5)

					ShareLink(item: url)
				}
			}
		}
    }
	
	init(url: URL?, @ViewBuilder content: () -> Content) {
		self.url = url
		self.content = content()
	}
}

//#Preview {
//    SheetView()
//}
