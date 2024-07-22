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
				.font(.custom("Oswald", size: 12).weight(.regular))
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
				.foregroundStyle(today ? .black : .newsFg1)
				.background(today ? .newsFg1 : .clear)
                .clipShape(RoundedRectangle(cornerRadius: today ? 24 : 0))
				.onAppear {
					today = relativeDate == "TODAY"
				}
        }
    }
}

#Preview {
    RelativeTimeCell(pushDate: Date())
}
