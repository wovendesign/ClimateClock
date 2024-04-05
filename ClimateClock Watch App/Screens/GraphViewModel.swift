//
//  GraphViewModel.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//
import SwiftUI
import Foundation

enum LineType {
	case temperature
	case emission
}

struct EmissionData: Hashable {
	var type: LineType
	var value: Double
	// The year is now used for identity instead of a UUID so that we can animate between different datasets.
	var year: Date
}

struct GraphData: Identifiable, Equatable {
	
	var id = UUID()
	
	var title: String
	var peakTemperature: Double
	var endTemperature: Double
	var color: Color
	
	var temperatures: [EmissionData]
	var emissions: [EmissionData]
}

final class GraphViewModel: ObservableObject {
	@Published var models: [GraphData] = MockData.items

	@Published private(set) var currentModel: GraphData?
	@Published var currentModelId: GraphData.ID? {
		didSet {
			if currentModelId != oldValue {
				// Assign the current model once and only if it has changed:
				currentModel = models.first(where: { $0.id == currentModelId })
			}
		}
	}

	init() {
		if let model = models.first {
			self.currentModelId = model.id
			self.currentModel = model
		}
	}

	let gridLines: [Date] = [
		getDateFromYear(date: 1980),
		getDateFromYear(date: 1990),
		getDateFromYear(date: 2000),
		getDateFromYear(date: 2010),
		getDateFromYear(date: 2020),
		getDateFromYear(date: 2030),
		getDateFromYear(date: 2040),
		getDateFromYear(date: 2050),
		getDateFromYear(date: 2060),
		getDateFromYear(date: 2070),
		getDateFromYear(date: 2080),
		getDateFromYear(date: 2090),
		getDateFromYear(date: 2100)
	]

	let gridMarks: [Date] = [
		getDateFromYear(date: 1980),
		getDateFromYear(date: 2020),
		getDateFromYear(date: 2060),
		getDateFromYear(date: 2100)
	]
}

struct MockData {
	static let items: [GraphData] = [
		GraphData(title: "Business as Usual",
				  peakTemperature: 3.52,
				  endTemperature: 3.52,
				  color: .red,
				  temperatures: [
					.init(type: .temperature, value: 0.8, year: getDateFromYear(date: 1980)),
					.init(type: .temperature, value: 0.92, year: getDateFromYear(date: 1990)),
					.init(type: .temperature, value: 1.12, year: getDateFromYear(date: 2000)),
					.init(type: .temperature, value: 1.41, year: getDateFromYear(date: 2010)),
					.init(type: .temperature, value: 1.76, year: getDateFromYear(date: 2020)),
					.init(type: .temperature, value: 2.11, year: getDateFromYear(date: 2030)),
					.init(type: .temperature, value: 2.41, year: getDateFromYear(date: 2040)),
					.init(type: .temperature, value: 2.7, year: getDateFromYear(date: 2050)),
					.init(type: .temperature, value: 2.97, year: getDateFromYear(date: 2060)),
					.init(type: .temperature, value: 3.18, year: getDateFromYear(date: 2070)),
					.init(type: .temperature, value: 3.34, year: getDateFromYear(date: 2080)),
					.init(type: .temperature, value: 3.45, year: getDateFromYear(date: 2090)),
					.init(type: .temperature, value: 3.52, year: getDateFromYear(date: 2100)),
				  ],
				  emissions: [
					.init(type: .emission, value: 0.8, year: getDateFromYear(date: 1980)),
					.init(type: .emission, value: 0.92, year: getDateFromYear(date: 1990)),
					.init(type: .emission, value: 1.12, year: getDateFromYear(date: 2000)),
					.init(type: .emission, value: 1.41, year: getDateFromYear(date: 2010)),
					.init(type: .emission, value: 1.76, year: getDateFromYear(date: 2020)),
					.init(type: .emission, value: 2.11, year: getDateFromYear(date: 2030)),
					.init(type: .emission, value: 2.4, year: getDateFromYear(date: 2070)),
					.init(type: .emission, value: 2.11, year: getDateFromYear(date: 2100)),
				  ]),
		GraphData(title: "Middle Ground",
				  peakTemperature: 2.7,
				  endTemperature: 2.7,
				  color: .orange,
				  temperatures: [
					.init(type: .temperature, value: 0.8, year: getDateFromYear(date: 1980)),
					.init(type: .temperature, value: 0.92, year: getDateFromYear(date: 1990)),
					.init(type: .temperature, value: 1.12, year: getDateFromYear(date: 2000)),
					.init(type: .temperature, value: 1.38, year: getDateFromYear(date: 2010)),
					.init(type: .temperature, value: 1.66, year: getDateFromYear(date: 2020)),
					.init(type: .temperature, value: 1.91, year: getDateFromYear(date: 2030)),
					.init(type: .temperature, value: 2.11, year: getDateFromYear(date: 2040)),
					.init(type: .temperature, value: 2.29, year: getDateFromYear(date: 2050)),
					.init(type: .temperature, value: 2.45, year: getDateFromYear(date: 2060)),
					.init(type: .temperature, value: 2.56, year: getDateFromYear(date: 2070)),
					.init(type: .temperature, value: 2.63, year: getDateFromYear(date: 2080)),
					.init(type: .temperature, value: 2.68, year: getDateFromYear(date: 2090)),
					.init(type: .temperature, value: 2.7, year: getDateFromYear(date: 2100)),
				  ],
				  emissions: [
					.init(type: .emission, value: 0.8, year: getDateFromYear(date: 1980)),
					.init(type: .emission, value: 0.92, year: getDateFromYear(date: 1990)),
					.init(type: .emission, value: 1.12, year: getDateFromYear(date: 2000)),
					.init(type: .emission, value: 1.38, year: getDateFromYear(date: 2010)),
					.init(type: .emission, value: 1.66, year: getDateFromYear(date: 2020)),
					.init(type: .emission, value: 1.86, year: getDateFromYear(date: 2030)),
					.init(type: .emission, value: 1.66, year: getDateFromYear(date: 2070)),
					.init(type: .emission, value: 0.8, year: getDateFromYear(date: 2100)),
				  ]),
		GraphData(title: "Green New Deal",
				  peakTemperature: 1.58,
				  endTemperature: 1.37,
				  color: .green,
				  temperatures: [
					.init(type: .temperature, value: 0.81, year: getDateFromYear(date: 1980)),
					.init(type: .temperature, value: 0.91, year: getDateFromYear(date: 1990)),
					.init(type: .temperature, value: 1.05, year: getDateFromYear(date: 2000)),
					.init(type: .temperature, value: 1.24, year: getDateFromYear(date: 2010)),
					.init(type: .temperature, value: 1.41, year: getDateFromYear(date: 2020)),
					.init(type: .temperature, value: 1.51, year: getDateFromYear(date: 2030)),
					.init(type: .temperature, value: 1.56, year: getDateFromYear(date: 2040)),
					.init(type: .temperature, value: 1.58, year: getDateFromYear(date: 2050)),
					.init(type: .temperature, value: 1.57, year: getDateFromYear(date: 2060)),
					.init(type: .temperature, value: 1.55, year: getDateFromYear(date: 2070)),
					.init(type: .temperature, value: 1.5, year: getDateFromYear(date: 2080)),
					.init(type: .temperature, value: 1.44, year: getDateFromYear(date: 2090)),
					.init(type: .temperature, value: 1.37, year: getDateFromYear(date: 2100)),
				  ],
				  emissions: [
					.init(type: .emission, value: 0.81, year: getDateFromYear(date: 1980)),
					.init(type: .emission, value: 0.91, year: getDateFromYear(date: 1990)),
					.init(type: .emission, value: 1.05, year: getDateFromYear(date: 2000)),
					.init(type: .emission, value: 1.24, year: getDateFromYear(date: 2010)),
					.init(type: .emission, value: 0, year: getDateFromYear(date: 2020)),
					.init(type: .emission, value: 0, year: getDateFromYear(date: 2030)),
					.init(type: .emission, value: 0, year: getDateFromYear(date: 2070)),
					.init(type: .emission, value: 0, year: getDateFromYear(date: 2100)),
				  ]),
	]
}
let temp_data: [EmissionData] = [
	.init(type: .temperature,
		  value: 0.5,
		  year: Calendar.autoupdatingCurrent.date(from: DateComponents(year: 1980))!),
	.init(type: .temperature,
		  value: 1.2,
		  year: Calendar.autoupdatingCurrent.date(from: DateComponents(year: 2020))!),
	.init(type: .temperature,
		  value: 2.9,
		  year: Calendar.autoupdatingCurrent.date(from: DateComponents(year: 2060))!),
	.init(type: .temperature,
		  value: 2.6,
		  year: Calendar.autoupdatingCurrent.date(from: DateComponents(year: 2100))!),
]

func getDateFromYear(date: Int) -> Date {
	return Calendar.autoupdatingCurrent.date(from: DateComponents(year: date))!;
}
