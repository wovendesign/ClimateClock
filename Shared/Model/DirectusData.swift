//
//  DirectusData.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation

struct DirectusResponse: Decodable {
	var data: [Idea]
}

struct DirectusIdeaInsertResponse: Decodable {
	var data: DirectusIdeaInsertData
}

struct DirectusIdeaInsertData: Decodable {
	var id: String
}

enum IdeaStatus: String, Codable {
	case pending, approved, rejected
}

struct Idea: Decodable, Identifiable {
	let id: UUID
	let status: IdeaStatus
	let date_created: String
	let title: String
	let idea: String
	let device_identifier: String
}

struct InsertableIdea: Codable {
	var status: IdeaStatus = .pending
	let title: String
	let idea: String
	let device_identifier: String
}
