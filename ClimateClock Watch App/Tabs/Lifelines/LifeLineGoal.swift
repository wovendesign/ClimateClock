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
			.applyTextStyle(.Footnote_Emphasized)
			.textCase(.uppercase)
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .foregroundStyle(.white)
            .padding(
                EdgeInsets(
                    top: 2,
                    leading: 4,
                    bottom: 3,
                    trailing: 4
                )
            )
            .background {
                Rectangle()
                    .fill(.black)
                    .cornerRadius(4.0)
            }
    }
}

#Preview {
    LifeLineGoal(goal: "100% before 2030")
}
