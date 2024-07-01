//
//  AboutView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 01.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct AboutView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Text("About the Climate Clock WatchOS App")
					.font(
						.custom("Oswald", size: 18)
							.weight(.semibold)
					)
					.tracking(0.32)
				
				Text("Join in and participate in the Climate Clock Community too.\n\n#ClimateClock #ActInTime")
				  .font(
					Font.custom("Assistant", size: 12)
					  .weight(.semibold)
				  )
				  .foregroundStyle(.gray)
				
				VStack(alignment: .leading) {
					Text("Development")
					  .font(
						Font.custom("Assistant", size: 13)
						  .weight(.semibold)
					  )
					  .foregroundColor(Color(red: 0.95, green: 0.96, blue: 0.99))
					HighlightedText(text: "This app was designed and developed by woven.\nwoven.design",
									highlighted: "woven.design",
									highlightColor: .red)
				}
				.onTapGesture {
					print("TODO: Open Sheet")
				}

			}
			.padding(.horizontal, 4)
		}
		.containerRelativeFrame(.horizontal)
	}
}

#Preview {
	AboutView()
}
