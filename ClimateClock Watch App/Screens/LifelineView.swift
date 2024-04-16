//
//  StatsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI

struct LifeLine {
	let value: Double
	let unit: String
	let label: String
	let precision: Int
}

struct LifelineView: View {
	let lifelines = [
		LifeLine(value: 26.7, unit: "%", label: "Women in parliaments globally", precision: 1),
		LifeLine(value: 13.676083240, unit: "%", label: "World's energy from renewables", precision: 9),
		LifeLine(value: 12.8312, unit: "trillion", label: "Loss & damage owed by G7 nations", precision: 4),
		LifeLine(value: 40.60, unit: "trillion", label: "Divested from fossil fuels", precision: 2),
		LifeLine(value: 43_500.000, unit: "km²", label: "Land protected by indigenous people", precision: 3),
		LifeLine(value: 1_013_455, unit: "HA", label: "Regenerative agriculture", precision: 0)
	]
	
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 12) {
				
				ForEachIndexed(lifelines) { index, item in
					LifeLineCell(value: item.value, unit: item.unit, precision: item.precision, label: item.label, index: index)
				}
			}
			.frame(maxWidth: .infinity)
			.padding(.horizontal, 8.0)
		}
		.frame(maxWidth: .infinity)
		.background(.linearGradient(colors: [.lime.opacity(0.4), .black],
									startPoint: .top,
									endPoint: .bottom))
	}
}


struct LifeLineCell: View {
	var value: Double
	var unit: String
	let precision: Int
	var label: String
	let index: Int
	
	@State private var animatedValue = 0.0
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text("\(animatedValue, specifier: "%0.\(precision)f")")
					.font(
						.custom("Oswald", size: 20)
						.weight(.medium)
					)
					.tracking(0.32)
					.contentTransition(.numericText(value: animatedValue))
					.animation(
						.linear(duration: 0.5).delay(0.5),
						value: animatedValue
					)
				Text(unit)
					.font(.lowercaseSmallCaps(
						.custom("Oswald", size: 20)
						.weight(.medium)
					)())
					.tracking(0.32)
					.fontWeight(.semibold)
			}
			.padding(EdgeInsets(top: 4,
								leading: 4,
								bottom: 4,
								trailing: 4))
			.background(.linearGradient(colors: [.lime, .aquaBlue],
										startPoint: .leading,
										endPoint: .trailing))
			.foregroundStyle(.black)
			.clipShape(.rect(cornerRadius: 6))
			Text(label)
				.font(
					.custom("Assistant", size: 12)
					.weight(.semibold)
				)
				.foregroundStyle(.white)
		}
		.onAppear {
			animatedValue = value
		}
	}
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
