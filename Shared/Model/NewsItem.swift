//
//  NewsItem.swift
//  ClimateClock
//
//  Created by Eric Wätke on 14.05.24.
//

import Foundation
import SwiftData

@Model
class NewsItem: Decodable {
	enum CodingKeys: CodingKey {
		case date, headline, headline_original, source, link, summary
	}
	
	@Attribute(.unique) var id: String {
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
