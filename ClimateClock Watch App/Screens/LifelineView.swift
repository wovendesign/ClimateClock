//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI

struct LifeLineValue {
    let timestamp: String // 2020-01-01T00:00:00+00:00
    let initial: Double
    let rate: Double
}

struct LifeLine {
    var prefix: String? = nil
    let value: LifeLineValue
    let unit: String
    let label: String
    let precision: Int
    var size: LifeLineSize = .Small
    var goal: String? = nil
}

struct LifelineView: View {
    let lifelines = [
        LifeLine(
            value: LifeLineValue(
                timestamp: "2023-02-14T00:00:00+00:00",
                initial: 26.9,
                rate: 0.0
            ),
            unit: "%",
            label: "Women in parliaments globally",
            precision: 1,
            size: .Large,
            goal: "100% before 2030"
        ),
        LifeLine(
            value: LifeLineValue(
                timestamp: "2020-01-01T00:00:00+00:00",
                initial: 11.4,
                rate: 2.0428359571070087e-8
            ),
            unit: "%",
            label: "World's energy from renewables",
            precision: 9,
            size: .Large,
            goal: "50%"
        ),
        LifeLine(
            prefix: "$",
            value: LifeLineValue(
                timestamp: "2020-01-01T00:00:00+00:00",
                initial: 11.192,
                rate: 1.26686668330479e-8
            ),
            unit: "trillion",
            label: "Loss & damage owed by G7 nations",
            precision: 8
        ),
        LifeLine(
            prefix: "$",
            value: LifeLineValue(
                timestamp: "2000-01-01T00:00:00+00:00",
                initial: 40.6,
                rate: 0
            ),
            unit: "trillion",
            label: "Divested from fossil fuels",
            precision: 2
        ),
        LifeLine(
            value: LifeLineValue(
                timestamp: "2021-10-01T00:00:00+00:00",
                initial: 43.5,
                rate: 0
            ),
            unit: "km²",
            label: "Land protected by indigenous people",
            precision: 1
        ),
        LifeLine(
            value: LifeLineValue(
                timestamp: "2021-10-01T00:00:00+00:00",
                initial: 1_302_905,
                rate: 0
            ),
            unit: "ha",
            label: "Regenerative agriculture",
            precision: 0
        ),
    ]

    var body: some View {
		ScrollView() {
			VStack(spacing: 0) {
				TabTitle(headline: "Lifelines", subtitle: "Change is already happening")
					.padding(.vertical, 48)
					.scrollTransition { content, phase in
						content.scaleEffect(phase.isIdentity ? 1.0 : 0.8, anchor: .bottom)
							.blur(radius: !phase.isIdentity ? 5.0 : 0)
							.opacity(phase.isIdentity ? 1.0 : 0.3)
					}
					.defaultScrollAnchor(.center)
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
					
				}
			}
			
		}
		.padding(.horizontal, 8.0)
		.padding(.vertical, 16)
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

struct LifeLineCell: View {
    let prefix: String?
    var value: LifeLineValue
    var unit: String
    let precision: Int
    var label: String
    let index: Int
    let size: LifeLineSize
    let goal: String?

    @State private var animatedValue = 0.0

    init?(prefix: String?, value: LifeLineValue, unit: String, precision: Int, label: String, index: Int, size: LifeLineSize, goal: String?, animatedValue: Double = 0.0) {
        let dateFormatter = ISO8601DateFormatter()

        guard let pastTimestamp = dateFormatter.date(from: value.timestamp) else {
            print("Couldnt calculate Timestamp")
            return nil
        }

        self.prefix = prefix
        self.value = value
        self.unit = unit
        self.precision = precision
        self.label = label
        self.index = index
        self.size = size
        self.goal = goal
        self.animatedValue = animatedValue
        timestamp = pastTimestamp
    }

    let timestamp: Date

    func valueByDate(date: Date) -> Double {
        let timeDifference = date.timeIntervalSince(timestamp)

        return value.initial + timeDifference * (value.rate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    VStack {
                        TimelineView(.periodic(from: .now, by: 0.3)) { context in
                            Text("\(prefix ?? "")\(valueByDate(date: context.date), specifier: "%0.\(precision)f") \(unit)")
                                .font(
                                    .custom("Oswald", size: 20)
                                        .weight(.medium)
                                )
                                .monospacedDigit()
                                .tracking(0.32)
                                .contentTransition(
                                    .numericText(
                                        value: valueByDate(date: context.date)
                                    )
                                )
                                .animation(
                                    .linear(duration: 0.5).delay(0.5),
                                    value: valueByDate(date: context.date)
                                )
								.minimumScaleFactor(0.5)
								.lineLimit(1)
                        }
                    }

                    if size == .Large {
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

                if size == .Large {
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

            if size == .Small {
                Text(label)
                    .font(
                        .custom("Assistant", size: 12)
                            .weight(.semibold)
                    )
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            let dateFormatter = ISO8601DateFormatter()

            guard let pastTimestamp = dateFormatter.date(from: value.timestamp) else {
                print("Couldnt calculate Timestamp")
                return
            }

            let currentTime = Date()
            let timeDifference = currentTime.timeIntervalSince(pastTimestamp)

            let newValue = value.initial + timeDifference * value.rate

            withAnimation {
                animatedValue = newValue
            }
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
