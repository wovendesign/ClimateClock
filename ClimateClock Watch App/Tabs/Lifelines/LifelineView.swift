//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftData
import SwiftUI

struct LifelineView: View {
    @Query(sort: \LifeLine.order) var lifeLines: [LifeLine]

    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				ForEach(lifeLines) { lifeLine in
					LifeLineCell(lifeLine: lifeLine)
				}
			}
			.padding(.horizontal, 8.0)
			.padding(.vertical, 16)
		}
		.containerBackground(.lime75.opacity(0.5).gradient, for: .navigation)
//		.navigationTitle("Lifelines")
    }
}

#Preview {
    LifelineView()
}
