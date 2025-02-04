//
//  DirectusData.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation
import SwiftData

struct DirectusResponse: Decodable {
	var data: [Idea]
}

struct DirectusIdeaInsertResponse: Decodable {
	var data: DirectusIdeaInsertData
}

struct DirectusIdeaInsertData: Decodable {
	var id: UUID
}

enum IdeaStatus: String, Codable {
	case pending, approved, rejected
}

//struct Idea: Decodable, Identifiable {
//	let id: UUID
//	let status: IdeaStatus
//	let date_created: String
//	let title: String
//	let idea: String
//	let device_identifier: String
//}

@Model
class Idea: Decodable {
	@Attribute(.unique) var id: UUID
	let status: IdeaStatus
	let date_created: Date
	let title: String
	let idea: String
	let device_identifier: String
	let votes: [UUID]
	
	init(id: UUID, status: IdeaStatus, date_created: Date, title: String, idea: String, device_identifier: String, votes: [UUID]) {
		self.id = id
		self.status = status
		self.date_created = date_created
		self.title = title
		self.idea = idea
		self.device_identifier = device_identifier
		self.votes = votes
	}
	
	// Define CodingKeys to map JSON keys to properties
	enum CodingKeys: String, CodingKey {
		case id
		case status
		case date_created
		case title
		case idea
		case device_identifier
		case votes
	}
	
	// Implement Decodable initializers
	required convenience init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let id = try container.decode(UUID.self, forKey: .id)
		let status = try container.decode(IdeaStatus.self, forKey: .status)
		let dateString = try container.decode(String.self, forKey: .date_created)
		let title = try container.decode(String.self, forKey: .title)
		let idea = try container.decode(String.self, forKey: .idea)
		let device_identifier = try container.decode(String.self, forKey: .device_identifier)
		
		// Decode votes array which contains objects with `device_identifier`
		var votes: [UUID] = []
		if container.contains(.votes) {
			var votesContainer = try container.nestedUnkeyedContainer(forKey: .votes)
			while !votesContainer.isAtEnd {
				let voteContainer = try votesContainer.nestedContainer(keyedBy: CodingKeys.self)
				let voteDeviceIdentifier = try voteContainer.decode(String.self, forKey: .device_identifier)
				if let uuid = UUID(uuidString: voteDeviceIdentifier) {
					votes.append(uuid)
				}
			}
		}
		
		// Convert dateString to Date
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		if let date = dateFormatter.date(from: dateString) {
			self.init(id: id, status: status, date_created: date, title: title, idea: idea, device_identifier: device_identifier, votes: votes)
		} else {
			throw DecodingError.dataCorruptedError(forKey: .date_created, in: container, debugDescription: "Date string does not match format expected by formatter.")
		}
	}
}

struct InsertableIdea: Codable {
	var status: IdeaStatus = .pending
	let title: String
	let idea: String
	let device_identifier: String
}
