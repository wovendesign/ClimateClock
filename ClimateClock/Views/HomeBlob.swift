//
//  HomeBlob.swift
//  ClimateClock
//
//  Created by Eric Wätke on 10.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct HomeBlob: View {
	let headerForegroundColor: Color
	let headerBackgroundColor: Color
	let headerImage: String
	let headerText: String?
	
	let headline: String
	let description: String?
	
	let buttonText: String
	let buttonImage: String
//	let buttonAction: () -> Void
	let buttonColor: Color
	
	let foregroundColor: Color
	let backgroundColor: Color
	
    var body: some View {
		VStack(alignment: .leading, spacing: 24) {
			VStack(alignment: .leading, spacing: 12) {
				if let headerText = headerText {
					HStack {
						Image(systemName: headerImage)
						Text(headerText)
							.font(.custom("Oswald", size: 17).weight(.medium))
					}
					.padding(4)
					.foregroundStyle(headerForegroundColor)
					.background(headerBackgroundColor)
					.clipShape(.rect(cornerRadius: 4))
				}

				
				VStack(alignment: .leading, spacing: 8) {
					HStack() {
						Text(headline)
							.font(.custom("Oswald", size: 26).weight(.medium))
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
						Spacer()
					}
					if let description = description {
						Text(description)
							.font(.custom("Assistant", size: 17, relativeTo: .body))
							.opacity(0.7)
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
					}
				}
				.frame(maxWidth: .infinity)
			}
			.frame(maxWidth: .infinity)
				
			HStack(spacing: 8) {
				Text(buttonText)
					.font(.custom("Oswald", size: 18).weight(.semibold))
				Image(systemName: buttonImage)
			}
			.foregroundStyle(buttonColor)
		}
		.frame(maxWidth: .infinity)
		.padding(.horizontal, 32)
		.padding(.vertical, 26)
		.clipShape(.rect(cornerRadius: 24))
    }
}

#Preview {
	HomeBlob(headerForegroundColor: .black,
			 headerBackgroundColor: .red.opacity(0.2),
			 headerImage: "heart",
			 headerText: "#ActInTime",
			 headline: "View the Action Clock",
			 description: "Quickly access the Deadline and Lifelines.",
			 buttonText: "Open Website",
			 buttonImage: "arrow.up.forward",
			 buttonColor: .red,
			 foregroundColor: .black,
			 backgroundColor: .white)
}
