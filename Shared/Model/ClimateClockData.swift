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
    var newsfeed_1: NewsFeedModule
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

struct NewsFeedModule: Decodable {
    let type: String
    let flavor: String
    let description: String
    let update_interval_seconds: Int
    let lang: String
    let newsfeed: [NewsItem]
}

struct NewsItem2: Codable, Equatable, Identifiable {
    var id: String {
        var hasher = Hasher()
        hasher.combine(headline)
        hasher.combine(link)
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
    //	var new: Bool = true
    var pushDate: Date?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        headline = try container.decode(String.self, forKey: .headline)
        headline_original = try container.decodeIfPresent(String.self, forKey: .headline_original)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        pushDate = nil
    }
}
