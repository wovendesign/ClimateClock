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
			VStack {
				Spacer()
				Image(ImageResource(name: "CCEarthGood", bundle: .main))
				Spacer()
			}
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
			.padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
		}
		
		.frame(
			width: WKInterfaceDevice.current().screenBounds.width,
			height: WKInterfaceDevice.current().screenBounds.height
		)
		.ignoresSafeArea()
	}
}

#Preview {
	TabTitle(
		headline: "Lifelines",
		subtitle: "Real-Time Progess on Climate Solutions"
	)
}
