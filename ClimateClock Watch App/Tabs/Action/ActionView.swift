//
//  AboutView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI

struct SelectedAction: Equatable {
	let cta: String
	let description: String
	let url: String
}

struct ActionView: View {
	@State var sheetOpen = false
	@State var selectedAction: SelectedAction?
	
    var body: some View {
        ScrollView {
			VStack(alignment: .leading, spacing: 16) {
                Text("3 Ways to Use a CLIMATE CLOCK")
                    .font(
                        .custom("Oswald", size: 18)
                            .weight(.semibold)
                    )
                    .tracking(0.32)
                    .padding()

                ActionItem(image: "megaphone",
                           title: "Megaphone",
                           description: "The clock helps decision-makers and the wider public understand that we are in a Climate Emergency.",
                           callToAction: "Sound the alarm",
						   url: "https://climateclock.world/earth-day-2024#page-section-62742a9e506a125c651656a1",
						   selectedAction: $selectedAction)
                ActionItem(image: "magnet",
                           title: "Magnet",
                           description: "Bring the media and politicians to you! Use the clock to attract media attention to your action on a new level!",
                           callToAction: "Attract Media",
						   url: "https://climateclock.world/earth-day-2024#page-section-62742a9e506a125c651656a6",
						   selectedAction: $selectedAction)
                ActionItem(image: "key",
                           title: "Key",
                           description: "Open up doors to decision-makers. The clock can get you access to decision-makers that previously ignored you.",
                           callToAction: "Open Up Doors",
						   url: "https://climateclock.world/earth-day-2024#page-section-62742a9e506a125c651656aa",
						   selectedAction: $selectedAction)
            }
			.padding(.horizontal, 4)
        }
		.onChange(of: selectedAction, { oldValue, newValue in
			if (newValue != nil) {
				sheetOpen = true
			}
		})
		.containerRelativeFrame(.horizontal)
		.sheet(isPresented: $sheetOpen, onDismiss: {
			selectedAction = nil
		}, content: {
			if let action = selectedAction {
				ScrollView {
					VStack(alignment: .leading) {
						Text(action.cta)
							.applyTextStyle(.Paragraph_Highlighted)
						Text(action.description)
							.applyTextStyle(.Label)
						
						if let url = URL(string: action.url) {
							SheetButtonGroup(notificationTitle: action.cta,
											 notificationBody: action.description,
											 url: url)
						}
					}
				}
			}
		})
    }
}

#Preview {
	ActionView()
}
