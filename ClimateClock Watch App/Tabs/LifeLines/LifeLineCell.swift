//
//  LifeLineCell.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.05.24.
//

import SwiftUI

struct LifeLineCell: View {
	let lifeLine: LifeLine
	var label: String?
	@State private var animatedValue = 0.0
	let timestamp: Date
	let unit: String
	let prefix = ""
	
	init(lifeLine: LifeLine) {
		let dateFormatter = ISO8601DateFormatter()
		
		let pastTimestamp = dateFormatter.date(from: lifeLine.timestamp) ?? Date()
		
		self.lifeLine = lifeLine
		self.label = lifeLine.labels.first
		self.animatedValue = 0.0
		self.timestamp = pastTimestamp
		self.unit = lifeLine.unit_labels.first ?? "n"
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			VStack(alignment: .leading) {
				VStack(alignment: .leading) {
					VStack {
						TimelineView(.periodic(from: .now, by: 0.3)) { context in
							Text("\(prefix ?? "")\(valueByDate(date: context.date), specifier: "%0.\(resolutionToPrecision(lifeLine.resolution))f") \(unit)")
								.font(
									.custom("Oswald", size: 20)
									.weight(.medium)
								)
								.monospacedDigit()
								.tracking(0.32)
								.contentTransition(
									.numericText(
										value: valueByDate(date: context.date)
									)
								)
								.animation(
									.linear(duration: 0.5).delay(0.5),
									value: valueByDate(date: context.date)
								)
								.minimumScaleFactor(0.5)
								.lineLimit(1)
						}
					}
					
					if lifeLine.size == .large {
						Text(label ?? "")
							.font(
								.custom("Assistant", size: 12)
								.weight(.semibold)
							)
					}
				}
				.padding(
					lifeLine.size == .large ? EdgeInsets(top: 6, leading: 6, bottom: 0, trailing: 6) : EdgeInsets()
				)
				
				if lifeLine.size == .large {
					Text("Our goal: ")
						.font(
							.custom("Oswald", size: 14)
							.weight(.medium)
						)
						.tracking(0.2)
						.scaledToFill()
						.minimumScaleFactor(0.5)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(
							EdgeInsets(
								top: 4,
								leading: 6,
								bottom: 5,
								trailing: 6
							)
						)
						.background(.black)
						.clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 17, bottomTrailing: 17, topTrailing: 0)))
				}
			}
			.padding(EdgeInsets(top: 2,
								leading: 2,
								bottom: 2,
								trailing: 2))
			.background(.linearGradient(colors: [.lime, .aquaBlue],
										startPoint: .leading,
										endPoint: .trailing))
			.foregroundStyle(.black)
			.clipShape(.rect(cornerRadius:lifeLine.size == .small ? 6 : 18))
			
			if lifeLine.size == .small {
				Text(label ?? "")
					.font(
						.custom("Assistant", size: 12)
						.weight(.semibold)
					)
					.foregroundStyle(.white)
			}
		}
		.onAppear {
			let dateFormatter = ISO8601DateFormatter()
			
			guard let pastTimestamp = dateFormatter.date(from: lifeLine.timestamp) else {
				print("Couldnt calculate Timestamp")
				return
			}
			
			let currentTime = Date()
			let timeDifference = currentTime.timeIntervalSince(pastTimestamp)
			
			let newValue = lifeLine.initial + timeDifference * lifeLine.rate
			
			withAnimation {
				animatedValue = newValue
			}
			
			print(resolutionToPrecision(lifeLine.resolution))
		}
	}
	
	func valueByDate(date: Date) -> Double {
		let timeDifference = date.timeIntervalSince(timestamp)
		
		return lifeLine.initial + timeDifference * (lifeLine.rate)
	}
	
	func resolutionToPrecision(_ resolution: Double) -> Int {
		let log10Resolution = log10(abs(resolution))
		let precision = max(0, floor(log10Resolution + 1))
		return Int(precision)
	}
}


//#Preview {
//	LifeLineCell()
//}
