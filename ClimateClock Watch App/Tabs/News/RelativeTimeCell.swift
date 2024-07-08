//
//  RelativeTimeCell.swift
//  ClimateClock
//
//  Created by Eric Wätke on 17.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct RelativeTimeCell: View {
    let pushDate: Date?
    var relativeDate: String {
        guard let pushDate else {
            return "No Date"
        }
        if pushDate.distance(to: Date()) < 86400 {
            return "TODAY"
        }
        return pushDate.formatted(.relative(presentation: .named))
    }

    var body: some View {
        if pushDate != nil {
            if relativeDate == "TODAY" {
                Text(relativeDate)
                    .font(
                        .custom("Oswald", size: 12)
                            .weight(.semibold)
                    )
                    .padding(EdgeInsets(top: 1.5,
                                        leading: 6,
                                        bottom: 2,
                                        trailing: 6))
                    .foregroundStyle(.black)
                    .background(.lifelineFg1)
                    .clipShape(.capsule)
            } else {
                Text(relativeDate)
                    .font(
                        .custom("Oswald", size: 12)
                            .weight(.semibold)
                    )
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    RelativeTimeCell(pushDate: Date())
}
