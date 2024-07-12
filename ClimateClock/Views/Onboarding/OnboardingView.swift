//
//  Onboarding.swift
//  ClimateClock
//
//  Created by Eric Wätke on 10.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct OnboardingItem: Hashable {
	let id: Int
	let image: String
	let title: String
	let description: String?
	let buttonText: String
}

struct OnboardingView: View {
	let item: OnboardingItem
	let buttonAction: () -> Void
	
	var body: some View {
		VStack {
			Image(item.image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding(.top, 16)
                .scaleEffect(item.image == "onboarding_1" ? 1.02 : 1)
                .padding(.top, item.image == "onboarding_1" ? -4 : 0)
			
			Spacer()
			VStack(spacing: 8) {
				Text(item.title)
					.font(.custom("Oswald", size: 26).weight(.medium))
					.environment(\._lineHeightMultiple, 0.8)
				if let description = item.description {
					Text(description)
						.font(.custom("Assistant", size: 17))
						.opacity(0.6)
				}
				HStack {
					Spacer()
					Button(action: buttonAction) {
						HStack {
							Text(item.buttonText)
								.font(.custom("Oswald", size: 18).weight(.semibold))
							Image("arrow-onboarding")
						}
					}
					.padding(.horizontal, 17)
					.padding(.vertical, 13)
					.background(Color(red: 0.25, green: 0.25, blue: 0.25))
					.foregroundStyle(.white)
					.clipShape(.rect(cornerRadius: 12))
				}
			}
			.padding(.horizontal, 16)
		}
		.padding(.top, 16)
		.padding(.bottom, 48)
        
	}
}

//#Preview {
//	Onboarding(sheetOpen: <#T##Binding<Bool>#>)
//}
