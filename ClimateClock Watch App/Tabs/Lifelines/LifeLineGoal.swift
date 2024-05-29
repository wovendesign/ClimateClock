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
        Text("Our goal: \(goal)")
            .font(
                .custom("Oswald", size: 14)
                    .weight(.medium)
            )
            .tracking(0.2)
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(
                EdgeInsets(
                    top: 4,
                    leading: 6,
                    bottom: 5,
                    trailing: 6
                )
            )
            .background(.black)
            .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 17, bottomTrailing: 17, topTrailing: 0)))
    }
}

#Preview {
    LifeLineGoal(goal: "100% before 2030")
}
