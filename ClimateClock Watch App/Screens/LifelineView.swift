//
//  StatsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI

struct LifeLine {
	var prefix: String? = nil
	let value: Double
	let unit: String
	let label: String
	let precision: Int
	var size: LifeLineSize = .Small
	var goal: String? = nil
}

struct LifelineView: View {
	let lifelines = [
		LifeLine(value: 26.7, unit: "%", label: "Women in parliaments globally", precision: 1, size: .Large, goal: "100% before 2030"),
		LifeLine(value: 13.676083240, unit: "%", label: "World's energy from renewables", precision: 9, size: .Large, goal: "50%"),
		LifeLine(prefix: "$", value: 12.8312, unit: "trillion", label: "Loss & damage owed by G7 nations", precision: 4),
		LifeLine(prefix: "$", value: 40.60, unit: "trillion", label: "Divested from fossil fuels", precision: 2),
		LifeLine(value: 43_500.000, unit: "km²", label: "Land protected by indigenous people", precision: 3),
		LifeLine(value: 1_013_455, unit: "HA", label: "Regenerative agriculture", precision: 0)
	]
	
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 12) {
				
				ForEachIndexed(lifelines) { index, item in
					LifeLineCell(
						prefix: item.prefix,
						value: item.value,
						unit: item.unit,
						precision: item.precision,
						label: item.label,
						index: index,
						size: item.size,
						goal: item.goal
					)
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

enum LifeLineSize {
	case Large, Small
}

struct LifeLineCell: View {
	let prefix: String?
	var value: Double
	var unit: String
	let precision: Int
	var label: String
	let index: Int
	let size: LifeLineSize
	let goal: String?
	
	@State private var animatedValue = 0.0
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			VStack(alignment: .leading) {
				VStack(alignment: .leading) {
					HStack {
						Text("\(prefix ?? "")\(animatedValue, specifier: "%0.\(precision)f")")
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
					
					if(size == .Large) {
						Text(label)
							.font(
								.custom("Assistant", size: 12)
								.weight(.semibold)
							)
					}
				}
				.padding(
					size == .Large ? EdgeInsets(top: 6, leading: 6, bottom: 0, trailing: 6) : EdgeInsets()
				)
				
				if(size == .Large) {
					Text("Our goal: \(goal ?? "")")
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
			.padding(EdgeInsets(top: 2,
								leading: 2,
								bottom: 2,
								trailing: 2))
			.background(.linearGradient(colors: [.lime, .aquaBlue],
										startPoint: .leading,
										endPoint: .trailing))
			.foregroundStyle(.black)
			.clipShape(.rect(cornerRadius: size == .Small ? 6 : 18))
			
			if(size == .Small) {
				Text(label)
					.font(
						.custom("Assistant", size: 12)
						.weight(.semibold)
					)
					.foregroundStyle(.white)
			}
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
