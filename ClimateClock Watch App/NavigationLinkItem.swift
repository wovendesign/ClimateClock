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
	
	let title: String?
	let secondaryTitle: String?
	let description: String?
	let icon: String
	let color: AnyGradient
	
    var body: some View {
			NavigationLink(value: page) {
				HStack {
					VStack (alignment: .leading) {
						if let title = title {
							Text(title)
								.font(
									.custom("Oswald", size: 18)
									.weight(.semibold)
								)
								.tracking(0.32)
								.environment(\._lineHeightMultiple, 0.75)
								.padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
						}
						if let secondaryTitle = secondaryTitle {
							Text(secondaryTitle)
								.font(
									.custom("Oswald", size: 16)
									.weight(.regular)
								)
								.tracking(0.32)
								.environment(\._lineHeightMultiple, 0.75)
								// Top Padding when no other title exists
								.padding(EdgeInsets(top: title == nil ? 4 : 0, leading: 0, bottom: 0, trailing: 0))
						}
						if let description = description {
							Text(description)
								.font(
									.custom("Assistant", size: 12)
										.weight(.regular)
								)
						}
					}
					.padding(.vertical, 16)
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
			self.color = Color.gray.gradient
			self.title = nil
			self.secondaryTitle = "3 Ways to Use a CLIMATE CLOCK"
			self.description = nil
			self.icon = "megaphone"
		case .lifeline:
			self.color = Color.lime50.gradient
			self.title = "Lifeline"
			self.secondaryTitle = nil
			self.description = "Change is already happening!"
			self.icon = "lifeline"
		case .news:
			self.color = Color.navy50.gradient
			self.title = "Newsfeed of Hope"
			self.secondaryTitle = nil
			self.description = "Daily news of recent climate victories."
			self.icon = "news"
		case .deadline:
			self.color = Color.ccRed50.gradient
			self.title = "Deadline"
			self.secondaryTitle = "6y 12d 01:26:37"
			self.description = nil
			self.icon = "deadline"
		}
	}
}

#Preview {
	NavigationLinkItem(page: .news)
}
