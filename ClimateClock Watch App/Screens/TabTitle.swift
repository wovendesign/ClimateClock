//
//  TabTitle.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 18.04.24.
//

import SwiftUI

struct TabTitle: View {
    var body: some View {
		ZStack {
			VStack {
				Text("Lifelines")
					.font(
						.custom("Oswald", size: 16)
							.weight(.regular)
					)
					.tracking(0.32)
				Text("Real-Time Progess on Climate Solutions")
			}
		}
    }
}

#Preview {
    TabTitle()
}





