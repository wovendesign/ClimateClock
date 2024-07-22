//
//  Countdown.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//
import ClockKit
import SwiftUI


struct DeadlineContent {
	let years: Int
	let days: Int
	let hours: Int
	let minutes: Int
	let seconds: Int
}

struct DeadlineEntry {
	let date: Date
	let deadline: String
}

func parseDateString(_ dateString: String) -> Date? {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
	return dateFormatter.date(from: dateString)
}
func dateDiff(deadline: Date, now: Date) -> DateComponents {
	let calendar = Calendar.current
	
	let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: deadline)
	
	return components
}

func diff(deadline: String) -> DeadlineContent {
	if let deadline = parseDateString(deadline) {
		let now = Date()
		
		let diffComponents = dateDiff(deadline: deadline, now: now)
		
		return DeadlineContent(
			years: diffComponents.year ?? 0,
			days: diffComponents.day ?? 4,
			hours: diffComponents.hour ?? 0,
			minutes: diffComponents.minute ?? 0,
			seconds: diffComponents.second ?? 0)
	} else {
		return DeadlineContent(years: 0, days: 5, hours: 0, minutes: 0, seconds: 0)
	}
}

struct DeadlineView: View {
	@State var isTomorrow = false
	
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
		let todayTimer = Calendar.current.date(from: todayTimerComponents)!
		
		GeometryReader { proxy in
			
			let relativeTextSize = proxy.size.width / 4.5
			
			VStack(alignment: .leading, spacing: 0) {
				HStack(alignment: .bottom, spacing: 3) {
					Text("\(diff(deadline: entry.deadline).years)")
						.font(
							.custom("Oswald", size: relativeTextSize)
							.weight(.bold)
						)
						.foregroundColor(Color(red: 0.99, green: 0.27, blue: 0.27))
						.monospacedDigit()
					Text("YEARS")
						.applyTextStyle(.Label_Emphasized)
						.foregroundColor(Color(red: 0.99, green: 0.27, blue: 0.27))
						.padding(.bottom, 8)
					
					Text("\(diff(deadline: entry.deadline).days)")
						.font(
							.custom("Oswald", size: relativeTextSize)
								.weight(.bold)
						)
						.foregroundColor(Color(red: 0.99, green: 0.27, blue: 0.27))
						.monospacedDigit()
						.padding(.leading, 6)
						.contentTransition (
							.numericText(value: Double(diff(deadline: entry.deadline).days))
						)
					Text("DAYS")
						.applyTextStyle(.Label_Emphasized)
						.foregroundColor(Color(red: 0.99, green: 0.27, blue: 0.27))
						.monospacedDigit()
						.padding(.bottom, 8)
					
				}
				.shadow(color: .deadlineForeground1.opacity(0.6), radius: 2)
				Text(isTomorrow ? tomorrowTimer : todayTimer, style: .timer)
					.allowsTightening(true)
					.font(
						.custom("Oswald", size: relativeTextSize)
						.weight(.light)
					)
					.lineSpacing(relativeTextSize/2)
					.tracking(3)
					.foregroundColor(Color(red: 0.99, green: 0.27, blue: 0.27))
					.monospacedDigit()
					.contentTransition(
						
						.numericText(countsDown: true)
					)
					.padding(.top, -relativeTextSize/3)
					.shadow(color: .deadlineForeground1.opacity(0.6), radius: 2)
				
				Text("Time left to limit global warming to 1.5°c")
					.applyTextStyle(.Label)
					.lineLimit(2)
					.padding(.top, relativeTextSize/6)
					.foregroundColor(Color(red: 0.99, green: 0.27, blue: 0.27))
					.frame(width: 153, alignment: .leading)
			}
			.padding(.leading, 10)
			.containerBackground(
				LinearGradient(
					stops: [
						Gradient.Stop(color: Color(red: 0.81, green: 0.04, blue: 0.02).opacity(0.075), location: 0.00),
						Gradient.Stop(color: Color(red: 0.81, green: 0.04, blue: 0.02).opacity(0.3), location: 1.00),
					],
					startPoint: .bottom,
					endPoint: .top),
				for: .navigation)
			.onAppear {
				updateIsTomorrow(todayTimer: todayTimer)
				Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
					withAnimation {
						updateIsTomorrow(todayTimer: todayTimer)
					}
				}
			}
		}
	}
	
	private func updateIsTomorrow(todayTimer: Date) {
		isTomorrow = todayTimer < Date()
	}
}

#Preview {
	DeadlineView()
}

