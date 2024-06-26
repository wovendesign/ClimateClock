//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftData
import SwiftUI

struct LifelineColor {
	var foregroundColor: Color
	var backgroundColor: Color
}

struct LifelineView: View {
    @Query(sort: \LifeLine.order) var lifeLines: [LifeLine]

	let colorGradients: [LifelineColor] = [
			LifelineColor(foregroundColor: Color(red: 224/255, green: 241/255, blue: 111/255),
						  backgroundColor: Color(red: 82/255, green: 88/255, blue: 25/255)),
			LifelineColor(foregroundColor: Color(red: 221/255, green: 237/255, blue: 145/255),
						  backgroundColor: Color(red: 54/255, green: 61/255, blue: 26/255)),
			LifelineColor(foregroundColor: Color(red: 200/255, green: 234/255, blue: 174/255),
						  backgroundColor: Color(red: 35/255, green: 43/255, blue: 29/255)),
			LifelineColor(foregroundColor: Color(red: 187/255, green: 232/255, blue: 198/255),
						  backgroundColor: Color(red: 33/255, green: 42/255, blue: 34/255)),
			LifelineColor(foregroundColor: Color(red: 186/255, green: 226/255, blue: 227/255),
						  backgroundColor: Color(red: 31/255, green: 41/255, blue: 41/255)),
			LifelineColor(foregroundColor: Color(red: 188/255, green: 221/255, blue: 251/255),
						  backgroundColor: Color(red: 29/255, green: 39/255, blue: 48/255))
		]
	
    var body: some View {
		
		List(lifeLines.indices, id: \.self) { index in
			LifeLineCell(lifeLine: lifeLines[index],
						 lifelineColor: (colorGradients.count > index ? colorGradients[index] : colorGradients.last)!)
			.listRowBackground(Color.clear)
			.contentMargins(4, for: .scrollContent)
		}
		.containerBackground(.lime75.opacity(0.5).gradient, for: .navigation)
    }
}

#Preview {
    LifelineView()
}
