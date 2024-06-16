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

enum LifeLineType: Codable {
	case renewables, agriculture, indigenous, g20, g7, women, youth, divestment, prolife
}

struct ClimateClockData: Decodable {
    let carbon_deadline_1: CarbonDeadline
    let renewables_1: LifeLineModule
    let regen_agriculture: LifeLineModule
    let indigenous_land_1: LifeLineModule
    let loss_damage_g20_debt: LifeLineModule
    let loss_damage_g7_debt: LifeLineModule
    let women_in_parliaments: LifeLineModule
    let ff_divestment_stand_dot_earth: LifeLineModule
    let _youth_anxiety: LifeLineModule
    let newsfeed_1: NewsFeedModule
}

struct CarbonDeadline: Decodable {}

enum apiType: String, Codable {
    case value, newsfeed, timer
}

enum apiFlavor: String, Codable {
    case lifeline, deadline
}

enum apiGrowth: String, Codable {
    case linear
}

struct LifeLineModule: Decodable {
    let type: apiType
    let flavor: apiFlavor
    let description: String
    let update_interval_seconds: Int
    let initial: Double
    let timestamp: String
    let growth: apiGrowth
    let resolution: Double
    let rate: Double
    let labels: [String]
    let unit_labels: [String]
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
