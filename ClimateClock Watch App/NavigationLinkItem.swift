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
	let foregroundColor: Color
	let backgroundColor: LinearGradient
	
	let entry = DeadlineEntry(date: Date(), deadline:"2029-07-22T16:00:00+00:00")
	
	var body: some View {
		
		let deadline = Calendar.current.dateComponents([.hour, .minute], from: parseDateString(entry.deadline)!)
		
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
		let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
		let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
		let tomorrowTimerComponents = DateComponents(
			year: tomorrowComponents.year ?? 0,
			month: tomorrowComponents.month ?? 0,
			day: tomorrowComponents.day,
			hour: deadline.hour,
			minute: deadline.minute
		)
		let todayTimerComponents = DateComponents(
			year: todayComponents.year ?? 0,
			month: todayComponents.month ?? 0,
			day: todayComponents.day,
			hour: deadline.hour,
			minute: deadline.minute
		)
		
		let tomorrowTimer = Calendar.current.date(from: tomorrowTimerComponents)!
		let isTomorrow = Calendar.current.isDateInToday(tomorrowTimer)
		let todayTimer = Calendar.current.date(from: todayTimerComponents)!
		
		NavigationLink(value: page) {
			VStack (alignment: .leading) {
				Image(icon)
				if let title = title {
					Text(title)
						.applyHeadlineStyle(.Section_Bold)
						.environment(\._lineHeightMultiple, 0.75)
						.padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
						.minimumScaleFactor(0.5)
						.textCase(.uppercase)
				}
				if let secondaryTitle = secondaryTitle {
					Text(secondaryTitle)
						.applyHeadlineStyle(.Section)
						.environment(\._lineHeightMultiple, 0.75)
					// Top Padding when no other title exists
						.padding(EdgeInsets(top: title == nil ? 4 : 0, leading: 0, bottom: 0, trailing: 0))
				}
				
				if title == "Deadline" {
					HStack(alignment: .bottom, spacing: 0) {
						Text("\(diff(deadline: entry.deadline).years)")
							.applyHeadlineStyle(.Section)
							.monospacedDigit()
						Text("y")
							.applyHeadlineStyle(.Section)
							.monospacedDigit()
						
						Text("\(diff(deadline: entry.deadline).days)")
							.applyHeadlineStyle(.Section)
							.monospacedDigit()
							.padding(.leading, 4)
						Text("d")
							.applyHeadlineStyle(.Section)
						Text(isTomorrow ? tomorrowTimer : todayTimer, style: .timer)
							.applyHeadlineStyle(.Section)
							.monospacedDigit()
							.padding(.leading, 4)
						
					}
				}
				
				if let description = description {
					Text(description)
						.font(
							.custom("Assistant", size: 16)
							.weight(.regular)
						)
						.lineLimit(3)
						.multilineTextAlignment(.leading)
						.environment(\._lineHeightMultiple, 0.75)
				}
			}
		}
		.frame(height: 116)
		.foregroundStyle(foregroundColor)
		.listRowBackground(Rectangle().foregroundStyle(backgroundColor).clipShape(.rect(cornerRadius: 18)))
	}
	
	init(page: Page) {
		self.page = page
		
		switch (page) {
		case .action:
			self.foregroundColor = .white
			self.backgroundColor = LinearGradient(
				colors: [
					Color(red: 0.17, green: 0.17, blue: 0.17),
					Color(red: 0.09, green: 0.09, blue: 0.09)
				],
				startPoint: .top,
				endPoint: .bottom)
			self.title = nil
			self.secondaryTitle = "3 Ways to Use a CLIMATE CLOCK"
			self.description = nil
			self.icon = "megaphone"
		case .lifeline:

            self.foregroundColor = Color(red: 170/255, green: 209/255, blue: 255/255)
            self.backgroundColor = LinearGradient(
                colors: [
                    Color(red: 0.14, green: 0.17, blue: 0.2),
                    Color(red: 0.05, green: 0.09, blue: 0.14)
                ],
                startPoint: .top,
                endPoint: .bottom)
			self.title = "Lifelines"
			self.secondaryTitle = nil
			self.description = "Follow real-time progress on key climate solutions"
			self.icon = "lifeline"
		case .news:
            self.foregroundColor = Color(red: 224/255, green: 241/255, blue: 111/255)
            self.backgroundColor = LinearGradient(
                colors: [
                    Color(red: 0.19, green: 0.19, blue: 0.13),
                    Color(red: 0.11, green: 0.11, blue: 0.07)
                ],
                startPoint: .top,
                endPoint: .bottom)
			self.title = "Newsfeed of Hope"
			self.secondaryTitle = nil
			self.description = "Daily newsfeed of climate victories."
			self.icon = "news"
		case .deadline:
			self.foregroundColor = Color(red: 255/255, green: 107/255, blue: 107/255)
			self.backgroundColor = LinearGradient(
				colors: [
					Color(red: 0.24, green: 0.16, blue: 0.16),
					Color(red: 0.16, green: 0.08, blue: 0.08)
				],
				startPoint: .top,
				endPoint: .bottom)
			self.title = "Deadline"
			self.secondaryTitle = nil
			self.description = nil
			self.icon = "deadline"
		}
	}
}

#Preview {
	NavigationLinkItem(page: .news)
}
