//
//  NewsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//
import AuthenticationServices
import SwiftUI

struct NewsView: View {
	var body: some View {
		ScrollView {
			VStack {
				ForEach(0...2, id: \.self) { i in
					VStack(alignment: .leading) {
						Text("Across the United States, houses of worship are going solar.")
							.fontDesign(.serif)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
					}
					.onTapGesture {
						guard let url = URL(string: "https://woven.design") else {
							return
						}
						
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
					.frame(maxWidth: .infinity)
					.background(Color.white.opacity(0.12))
					.clipShape(.rect(cornerRadius: 18))
//					.containerRelativeFrame(.vertical)
					.scrollTransition { content, phase in
						content.scaleEffect(phase.isIdentity ? 1.0 : 0.9)
					}
				}
			}
		}
		.frame(maxWidth: .infinity)
		.background(
			LinearGradient(gradient: Gradient(colors: [.black, Color(red: 0.384, green: 0.392, blue: 0.957)]),
						   startPoint: .top,
						   endPoint: .bottom)
			.opacity(0.3)
		)
		.contentMargins(.vertical, 8, for: .scrollContent)
		.scrollTargetBehavior(.viewAligned)
	}
}

#Preview {
	NewsView()
}
