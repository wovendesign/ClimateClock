//
//  Graph.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//

import SwiftUI
import Charts

struct Graph: View {
	var emissions: [EmissionData]
	var temperatures: [EmissionData]
	var color: Color
	var gridLines: [Date]
	
    var body: some View {
		Chart {
			ForEach(emissions) { emission in
				LineMark(
					x: .value("Year", emission.year),
					y: .value("Risk", emission.value)
				)
				.interpolationMethod(.catmullRom)
				.foregroundStyle(color)
				.foregroundStyle(by: .value("Risk", "Emissions"))
				.lineStyle(StrokeStyle(lineWidth: 2,
									   lineCap: .round))
				.opacity(1)
			}
			ForEach(temperatures) { temperature in
				LineMark(
					x: .value("Year", temperature.year),
					y: .value("Risk", temperature.value)
				)
				.interpolationMethod(.cardinal)
				.foregroundStyle(color)
				.foregroundStyle(by: .value("Risk", "Temperature"))
				.lineStyle(StrokeStyle(lineWidth: 6,
									   lineCap: .round))
				.opacity(0.5)
			}
		}
		.chartLegend(.hidden)
		.chartYAxisLabel(position: .leading,
						 alignment: .center,
						 spacing: 0) {
			Text("Risk")
				.font(.system(size: 10))
				.fontWeight(.bold)
		}
		.chartXAxis {
			AxisMarks(values: gridLines) {
				AxisGridLine()
			}
		}
		.chartYAxis {
			AxisMarks(values: [0]) {
				AxisGridLine()
			}
		}
		.chartYScale(domain: 0...4)
		.frame(maxHeight: 120)
    }
}

#Preview {
	Graph(emissions: temp_data, temperatures: temp_data, color: .red, gridLines: [getDateFromYear(date: 2020)])
}
