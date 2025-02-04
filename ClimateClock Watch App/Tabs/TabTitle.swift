//
//  TabTitle.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 18.04.24.
//

import SwiftUI

struct TabTitle: View {
	let headline: String
	let subtitle: String
	
	var body: some View {
		ZStack {
			Image("CCEarthGood")
			VStack(alignment: .leading) {
				Spacer()
					.frame(maxWidth: .infinity)
				Text(headline)
					.font(
						.custom("Oswald", size: 18)
						.weight(.semibold)
					)
					.tracking(0.32)
				Text(subtitle)
					.font(
						.custom("Assistant", size: 16)
						.weight(.regular)
					)
			}
			.frame(maxWidth: .infinity)
		}
		.listRowBackground(Color.clear)
		.frame(
			height: WKInterfaceDevice.current().screenBounds.height / 2
		)
		.padding(.vertical, 8)
		.ignoresSafeArea()
	}
}

#Preview {
	TabTitle(
		headline: "Lifelines",
		subtitle: "Real-Time Progess on Climate Solutions"
	)
}
