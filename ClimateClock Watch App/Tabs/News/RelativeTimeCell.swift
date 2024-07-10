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
	
	@State var today: Bool = false

    var body: some View {
        if pushDate != nil {
			Text(relativeDate)
				.padding(today ?
						 EdgeInsets(top: 1.5,
									leading: 6,
									bottom: 2,
									trailing: 6) 
						 : EdgeInsets(top: 0,
									  leading: 0,
									  bottom: 0,
									  trailing: 0)
				)
				.foregroundStyle(today ? .black : .gray)
				.background(today ? .lifelineFg1 : .clear)
				.clipShape(.capsule)
				.onAppear {
					today = relativeDate == "TODAY"
				}
        }
    }
}

#Preview {
    RelativeTimeCell(pushDate: Date())
}
