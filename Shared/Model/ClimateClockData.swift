//
//  ClimateClockData.swift
//  ClimateClock
//
//  Created by Eric Wätke on 28.02.24.
//

import Foundation

struct ClimateClockResponse: Decodable {
	var status: String
	var data: ClimateClockResponseModules
}

struct ClimateClockResponseModules: Decodable {
	var modules: ClimateClockData
}

struct ClimateClockData: Decodable {
	var carbon_deadline_1: ClimateClockModule
}

struct ClimateClockModule: Decodable {
	// Define properties based on the actual structure of each module
	// Example for "carbon_deadline_1":
	let type: String
	let flavor: String
	let description: String
	let update_interval_seconds: Int
	let timestamp: String
	let labels: [String]
	let lang: String
}
