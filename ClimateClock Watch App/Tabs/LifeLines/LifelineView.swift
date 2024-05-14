//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI
import SwiftData

struct LifelineView: View {
	@Query(sort: \LifeLine.order) var lifeLines: [LifeLine]
	
	var body: some View {
		ScrollView {
			VStack(spacing: 0) {
				TabTitle(
					headline: "Lifelines",
					subtitle: "Change is already happening"
				)
				.scrollTransition { content, phase in
					content.scaleEffect(phase.isIdentity ? 1.0 : 0.8, anchor: .bottom)
						.blur(radius: !phase.isIdentity ? 3.0 : 0)
						.opacity(phase.isIdentity ? 1.0 : 0.3)
				}
				.defaultScrollAnchor(.center)
				ScrollView {
					LazyVStack(alignment: .leading, spacing: 12) {
						ForEachIndexed(lifeLines) { index, lifeLine in
							LifeLineCell(lifeLine: lifeLine)
						}
					}
					.frame(maxWidth: .infinity)
				}
				.padding(.horizontal, 8.0)
				.padding(.vertical, 16)
			}
		}
		//			.contentMargins(.vertical, 12)
		.frame(maxWidth: .infinity)
		.ignoresSafeArea()
		.background(.linearGradient(colors: [.lime.opacity(0.4), .black],
									startPoint: .top,
									endPoint: .bottom))
	}
}

enum LifeLineSize {
	case Large, Small
}


#Preview {
	LifelineView()
}

struct ForEachIndexed<Data, Item, Content: View>: View where Data: RandomAccessCollection<Item>, Data.Index: Hashable {
	private let sequence: Data
	private let content: (Data.Index, Item) -> Content
	
	init(_ sequence: Data, @ViewBuilder _ content: @escaping (Data.Index, Item) -> Content) {
		self.sequence = sequence
		self.content = content
	}
	
	var body: some View {
		ForEach(Array(zip(sequence.indices, sequence)), id: \.0) { index, item in
			self.content(index, item)
		}
	}
}
