//
//  CCError.swift
//  ClimateClock
//
//  Created by Eric Wätke on 01.04.24.
//

import Foundation

enum CCError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
	case unableToComplete
}
