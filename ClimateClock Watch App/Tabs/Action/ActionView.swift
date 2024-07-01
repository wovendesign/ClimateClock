//
//  AboutView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI

struct ActionView: View {
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
                           callToAction: "Sound the alarm")
                ActionItem(image: "magnet",
                           title: "Magnet",
                           description: "Bring the media and politicians to you! Use the clock to attract media attention to your action on a new level!",
                           callToAction: "Attract Media")
                ActionItem(image: "key",
                           title: "Key",
                           description: "Open up doors to decision-makers. The clock can get you access to decision-makers that previously ignored you.",
                           callToAction: "Open Up Doors")
            }
			.padding(.horizontal, 4)
        }
		.containerRelativeFrame(.horizontal)
    }
}

#Preview {
	ActionView()
}
