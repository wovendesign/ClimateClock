//
//  DirectusData.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import Foundation

struct DirectusResponse: Decodable {
	var data: ClimateClockResponseModules
}

enum IdeaStatus: String, Decodable {
	case approved
}

struct Idea: Decodable, Identifiable {
	let id: UUID
	let status: IdeaStatus
	let date_created: String
	let idea: String
}
