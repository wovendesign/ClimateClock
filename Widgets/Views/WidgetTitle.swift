//
//  WidgetTitle.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct WidgetTitle: View {
	let title: String
	let withBackground: Bool
	
	var body: some View {
		VStack {
			Text(title)
				.textCase(.uppercase)
				.font(
					.custom("Assistant", size: 12)
				)
				.multilineTextAlignment(.center)
				.tracking(0.72)
				.padding(.horizontal, 12)
				.minimumScaleFactor(0.5)
		}
		.frame(height: 20)
		.frame(maxWidth: .infinity, alignment: .center)
		.background(withBackground ? .black.opacity(0.25) : Color.clear)
	}
}
