//
//  ClimateClockData.swift
//  ClimateClock
//
//  Created by Eric Wätke on 28.02.24.
//

import Foundation

struct ClimateClockResponse: Decodable, Encodable {
	var status: String
	var data: ClimateClockResponseModules
}

struct ClimateClockResponseModules: Decodable, Encodable {
	var modules: ClimateClockData
}

struct ClimateClockData: Decodable, Encodable {
	var carbon_deadline_1: ClimateClockModule
	var newsfeed_1: NewsFeedModule
}

struct ClimateClockModule: Decodable, Encodable {
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

struct NewsFeedModule: Decodable, Encodable {
	let type: String
	let flavor: String
	let description: String
	let update_interval_seconds: Int
	let lang: String
	let newsfeed: [NewsItem]
}

struct NewsItem: Codable, Equatable, Identifiable {
	var id: String {
		var hasher = Hasher()
		hasher.combine(self.headline)
		hasher.combine(self.link)
		return "\(hasher.finalize())"
	}
	let date: String
	let headline: String
	
//	Optional
	let headline_original: String?
	let source: String?
	let link: String?
	let summary: String?
	
//	Interactive Data
}
