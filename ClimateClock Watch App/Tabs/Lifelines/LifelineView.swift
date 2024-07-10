//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftData
import SwiftUI

struct LifelineColor {
	var foregroundColor: Color
	var backgroundColor: Color
}

struct SelectedLifeLine: Equatable {
	var precision: Int
	var unit: String
	var timestamp: Date
	var lifeLine: LifeLine
	var label: String
	var url: String
}

struct LifelineView: View {
	@Query(sort: \LifeLine.order) var lifeLines: [LifeLine]
	
	@State var sheetOpen = false
	@State var selectedLifeline: SelectedLifeLine?
	
	let colorGradients: [LifelineColor] = [
		LifelineColor(foregroundColor: Color(red: 170/255, green: 210/255, blue: 255/255),
					  backgroundColor: Color(red: 79/255, green: 102/255, blue: 126/255)),
		LifelineColor(foregroundColor: Color(red: 0.62, green: 0.83, blue: 0.93),
					  backgroundColor: Color(red: 68/255, green: 96/255, blue: 113/255)),
		LifelineColor(foregroundColor: Color(red: 0.58, green: 0.84, blue: 0.85),
					  backgroundColor: Color(red: 0.2, green: 0.35, blue: 0.37)),
		LifelineColor(foregroundColor: Color(red: 0.55, green: 0.85, blue: 0.81),
					  backgroundColor: Color(red: 0.19, green: 0.35, blue: 0.33)),
		LifelineColor(foregroundColor: Color(red: 0.64, green: 0.88, blue: 0.7),
					  backgroundColor: Color(red: 0.26, green: 0.37, blue: 0.31)),
		LifelineColor(foregroundColor: Color(red: 0.71, green: 0.9, blue: 0.62),
					  backgroundColor: Color(red: 0.29, green: 0.39, blue: 0.25)),
		
		LifelineColor(foregroundColor: Color(red: 0.8, green: 0.93, blue: 0.52),
					  backgroundColor: Color(red: 0.33, green: 0.42, blue: 0.16)),
		LifelineColor(foregroundColor: Color(red: 0.88, green: 0.95, blue: 0.44),
					  backgroundColor: Color(red: 0.88, green: 0.95, blue: 0.44))
	]
	
	var body: some View {
		
		List(lifeLines.indices, id: \.self) { index in
			LifeLineCell(lifeLine: lifeLines[index],
						 lifelineColor: (colorGradients.count > index ? colorGradients[index] : colorGradients.last)!,
						 selectedLifeLine: $selectedLifeline)
			.listRowBackground(Color.clear)
			.contentMargins(4, for: .scrollContent)
		}
		.onChange(of: selectedLifeline, { oldValue, newValue in
			if (newValue != nil) {
				sheetOpen = true
			}
		})
		.sheet(isPresented: $sheetOpen, onDismiss: {
			selectedLifeline = nil
		}, content: {
			if let lifeline = selectedLifeline {
				ScrollView {
					VStack(alignment: .leading) {
						LifeLineText(precision: lifeline.precision,
									 unit: lifeline.unit,
									 timestamp: lifeline.timestamp,
									 lifeLine: lifeline.lifeLine)
						Text(lifeline.label)
							.font(
								.custom("Oswald", size: 16)
							)
						Text("https://climateclock.world/science#renewable-energy")
							.font(
								.custom("Assistant", size: 12)
								.weight(.semibold)
							)
							.foregroundStyle(.white)
						if let url = URL(string: lifeline.url) {
							SheetButtonGroup(notificationTitle: "Learn More About",
											 notificationBody: lifeline.label,
											 url: url)
						}
					}
				}
			}
		})
		.containerBackground(.navy.gradient, for: .navigation)
	}
}

#Preview {
	LifelineView()
}
