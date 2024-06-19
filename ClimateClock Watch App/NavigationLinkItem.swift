//
//  NavigationLinkItem.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 19.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct NavigationLinkItem: View {
	let page: Page
	
	let title: String
	let description: String?
	let icon: String
	let color: AnyGradient
	
    var body: some View {
			NavigationLink(value: page) {
				HStack {
					VStack {
						Text(title)
						if let description = description {
							Text(description)
						}
					}
					Spacer()
					Image(icon)
				}
			}

			.listRowBackground(Rectangle().foregroundStyle(color).clipShape(.rect(cornerRadius: 18)).opacity(0.2))
    }
	
	init(page: Page) {
		self.page = page
		
		switch (page) {
		case .about:
			self.color = Color.navy50.gradient
			self.title = "3 Ways to Use a CLIMATE CLOCK"
			self.description = nil
			self.icon = "magnet"
		case .lifeline:
			self.color = Color.lime50.gradient
			self.title = "Lifeline"
			self.description = "Change is already happening!"
			self.icon = "magnet"
		case .news:
			self.color = Color.navy50.gradient
			self.title = "Newsfeed of Hope"
			self.description = "Daily news of recent climate victories."
			self.icon = "magnet"
		}
	}
}
struct MyNavViewButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(maxWidth: .infinity)
			.padding()
			.foregroundStyle(.purple)
			.background(configuration.isPressed ? .blue : .green)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.overlay {
				RoundedRectangle(cornerRadius: 10)
					.stroke(.red, lineWidth: configuration.isPressed ? 2 : 0)
			}
			.padding(3)
	}
}
struct BlueButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(.blue)
			.foregroundStyle(.white)
			.clipShape(Capsule())
	}
}

#Preview {
	NavigationLinkItem(page: .news)
}
