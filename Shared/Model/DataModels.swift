//
//  DataModels.swift
//  ClimateClock
//
//  Created by Eric Wätke on 14.05.24.
//

import Foundation
import SwiftData

enum NotificationType: String, Codable {
	case first
	case second
}

@Model
class NewsItem: Decodable {
    enum CodingKeys: CodingKey {
        case date, headline, headline_original, source, link, summary
    }

    let date: String
    @Attribute(.unique) let headline: String

    //	Optional
    let headline_original: String?
    let source: String?
    let link: String?
    let summary: String?

    //	Interactive Data
    //	var new: Bool = true
    var pushDate: Date?
	var scheduled: NotificationType?

    required init(from decoder: Decoder) throws {
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

@Model
class LifeLine {
	enum LifeLineSize: Codable {
		case small, large
	}
	
	@Attribute(.unique) let order: Int
	let size: LifeLineSize
	let desc: String
	let update_interval_seconds: Int
	let initial: Double
	let timestamp: String
	let growth: apiGrowth
	let resolution: Double
	let rate: Double
	let labels: [String]
	let unit_labels: [String]
    let goal: String?

    init(order: Int, size: LifeLineSize, desc: String, update_interval_seconds: Int, initial: Double, timestamp: String, growth: apiGrowth, resolution: Double, rate: Double, labels: [String], unit_labels: [String], goal: String?) {
		self.order = order
		self.size = size
		self.desc = desc
		self.update_interval_seconds = update_interval_seconds
		self.initial = initial
		self.timestamp = timestamp
		self.growth = growth
		self.resolution = resolution
		self.rate = rate
		self.labels = labels
		self.unit_labels = unit_labels
        self.goal = goal
	}
}
