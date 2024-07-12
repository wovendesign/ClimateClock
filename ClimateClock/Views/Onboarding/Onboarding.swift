//
//  Onboarding.swift
//  ClimateClock
//
//  Created by Eric Wätke on 10.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct Onboarding: View {
	@State private var currentTab = 1
	@Binding var sheetOpen: Bool
	
	let onboarding: [OnboardingItem] = [
		OnboardingItem(id: 1,
					   image: "onboarding_1",
					   title: "The Climate Clock melds art, science, technology, and grassroots organizing to get the world to #ActInTime.",
					   description: "Stay informed with lifelines, the climate clock, and the latest hopeful news updates on the climate clock.",
					   buttonText: "See how it Works"),
		OnboardingItem(id: 2,
					   image: "onboarding_2",
					   title: "Open your Apple Watch and start exploring our app.",
					   description: nil,
					   buttonText: "Next"),
		OnboardingItem(id: 3,
					   image: "onboarding_3",
					   title: "Use our widgets to stay informed and take action! Add them to your widget stack and watch faces.",
					   description: nil,
					   buttonText: "Done"),
	]
	
	var body: some View {
		TabView(
			selection: $currentTab,
			content:  {
				ForEach(onboarding, id: \.self) { item in
					OnboardingView(item: item, buttonAction: {
						print("Tap")
						if currentTab == 3 {
							sheetOpen = false
							return
						}
						
						withAnimation {
							currentTab += 1
						}
					})
						.tag(item.id)
				}
			})
		.tabViewStyle(PageTabViewStyle())
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
	}
}

//#Preview {
//	Onboarding()
//}
