//
//  ActionItem.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 15.05.24.
//

import SwiftUI

struct ActionItem: View {
    let image: String
    let title: String
    let description: String
    let callToAction: String

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(image)
                    Text(title)
                        .textCase(.uppercase)
                        .font(
                            .custom("Oswald", size: 18)
                                .weight(.semibold)
                        )
                        .tracking(0.32)
                }

                Text(description)
					.font(
						.custom("Assistant", size: 12)
						.weight(.semibold)
                    )
            }
            .padding(6)

            HStack {
                Text(callToAction)
                    .textCase(.uppercase)
                    .font(.custom("Oswald",
                                  size: 14))
				Spacer()
                Image("arrow_topright")
            }
			.padding(.horizontal, 6)
			.padding(.vertical, 4)
            .background(.aquaBlue)
            .foregroundStyle(.navy)
            .clipShape(.rect(cornerRadius: 5))
        }
        .padding(4)
        .background(.white.opacity(0.12))
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    ActionItem(image: "megaphone",
               title: "Megaphone",
               description: "The clock helps decision-makers and the wider public understand that we are in a Climate Emergency.",
               callToAction: "Sound the alarm")
}
