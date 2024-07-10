//
//  LifeLineCell.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.05.24.
//

import SwiftUI

struct LifeLineCell: View {
    let lifeLine: LifeLine
	let lifelineColor: LifelineColor
	@Binding var selectedLifeLine: SelectedLifeLine?
	
    @State var label: String?
    @State private var animatedValue = 0.0
	@State var timestamp: Date = Date()
    @State var unit: String = ""
    @State var precision: Int = 0

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
						LifeLineText(precision: precision, unit: unit, timestamp: timestamp, lifeLine: lifeLine)

                        if lifeLine.size == .large {
                            Text(label ?? "")
                                .font(
                                    .custom("Assistant", size: 12)
                                        .weight(.semibold)
                                )
                        }
                    }
                    .padding(
                        lifeLine.size == .large ? EdgeInsets(top: 6, leading: 6, bottom: 0, trailing: 6) : EdgeInsets(top: 0, leading: 6, bottom: -2, trailing: 6)
                    )

                    if lifeLine.size == .large {
                        if let goal = lifeLine.goal {
                            LifeLineGoal(goal: goal)
                                .padding(.leading, 4)
                        }
                    }
                }
                .frame(maxWidth: lifeLine.size == .large ? .infinity : nil, alignment: .leading)
                .padding(EdgeInsets(top: 0,
                                    leading: 0,
                                    bottom: 4,
                                    trailing: 0))
				.background(lifelineColor.backgroundColor.opacity(0.4))
				.foregroundStyle(lifelineColor.foregroundColor)
                .clipShape(.rect(cornerRadius: lifeLine.size == .small ? 6 : 8))

                if lifeLine.size == .small && label != nil {
                    HStack {
						Text(label!)
							.applyTextStyle(.Label)
							.foregroundStyle(.white)
                        Spacer()
                        Image("arrow_topright_4px_aquablue75")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 6, height: 6)
                            .frame(width: 14, height: 14)
							.foregroundStyle(.white.opacity(0.7))
                            .background {
                                Rectangle()
									.fill(Color(red: 0.25, green: 0.25, blue: 0.25))
                                    .cornerRadius(8.0)
                            }
                    }
                }
            }
            .onAppear {
				let dateFormatter = ISO8601DateFormatter()

				let pastTimestamp = dateFormatter.date(from: lifeLine.timestamp) ?? Date()


				label = lifeLine.labels.first
				animatedValue = 0.0
				timestamp = pastTimestamp

				// Get the shortest unit
				unit = lifeLine.unit_labels.sorted(by: { $0.count < $1.count }).first ?? "n"
				precision = resolutionToPrecision(lifeLine.resolution)
                calculateTimeAdjustedValue()
            }
            lifeLine.size == .large ? HStack(spacing: 2) {
				Text("Learn More")
					.applyTextStyle(.Footnote_Default)
					.foregroundColor(.white.opacity(0.7))

                Image("arrow_topright_4px_aquablue75")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 6, height: 6)
            }
            .frame(height: 14)
            .padding(EdgeInsets(top: 0,
                                leading: 4,
                                bottom: 0,
                                trailing: 6))
            .background {
                Rectangle()
					.fill(Color(red: 0.25, green: 0.25, blue: 0.25))
                    .cornerRadius(8.0)
            } : nil
        }
		.onTapGesture {
			var url: String = ""
			switch lifeLine.type {
			case .renewables:
				url = "https://climateclock.world/science#renewable-energy"
			case .agriculture:
				url = "https://climateclock.world/science#food"
			case .indigenous:
				url = "https://climateclock.world/science#indigenous-land"
			case .g20:
				url = "https://climateclock.world/science#loss-and-damage"
			case .g7:
				url = "https://climateclock.world/science#loss-and-damage"
			case .women:
				url = "https://climateclock.world/science#gp"
			case .youth:
				url = "https://climateclock.world/mental-health-awareness"
			case .divestment:
				url = "https://climateclock.world/science#ffd"
			case .prolife:
				url = "https://climateclock.world/"
			case .none:
				url = "https://climateclock.world/"
			}
			selectedLifeLine = SelectedLifeLine(precision: precision,
												unit: unit,
												timestamp: timestamp,
												lifeLine: lifeLine,
												label: label ?? "n",
												url: url)
		}
    }

    func calculateTimeAdjustedValue() {
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
    }

    func resolutionToPrecision(_ resolution: Double) -> Int {
        let log10Resolution = -log10(abs(resolution))
        let precision = max(0, floor(log10Resolution))
        return Int(precision)
    }
}

// #Preview {
//	LifeLineCell()
// }


struct LifeLineText: View {
	let precision: Int
	let unit: String
	let timestamp: Date
	let lifeLine: LifeLine
	
	var body: some View {
		TimelineView(.periodic(from: .now, by: 0.3)) { context in
			Text("\(valueByDate(date: context.date), specifier: "%0.\(precision)f") \(unit)")
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
	
	func valueByDate(date: Date) -> Double {
		let timeDifference = date.timeIntervalSince(timestamp)

		return lifeLine.initial + timeDifference * (lifeLine.rate)
	}
}
