//
//  LifeLineGoal.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 15.05.24.
//

import SwiftUI

struct LifeLineGoal: View {
    let goal: String
    var body: some View {
		Text("Goal: \(goal)")
			.font(
				.custom("Oswald", size: 10)
				.weight(.medium)
			)
            .textCase(.uppercase)
			.tracking(0.2)
			.scaledToFill()
			.minimumScaleFactor(0.5)
			.foregroundStyle(.white)
//            .frame(maxWidth: .infinity, alignment: .leading)
			.padding(
				EdgeInsets(
					top: 2,
					leading: 4,
					bottom: 3,
					trailing: 4
				)
			)
            .background{
                Rectangle()
                    .fill(.black)
                    .cornerRadius(4.0)
            }
//			.clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 17, bottomTrailing: 17, topTrailing: 0)))
    }
}

#Preview {
    LifeLineGoal(goal: "100% before 2030")
}
