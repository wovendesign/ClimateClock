//
//  Client.swift
//  ClimateClock
//
//  Created by Eric Wätke on 14.05.24.
//

import Foundation
import Observation

@Observable public final class Client {
	func fetchNewsFromAPI() async -> [NewsItem]? {
		do {
			let result = try await NetworkManager.shared.getClimateClockData()

			switch result {
			case let .success(data):
				return data.data.modules.newsfeed_1.newsfeed

			case let .failure(error):
				switch error {
				case .invalidURL:
					print("Invalid URL")
					//								alertItem = AlertContext.invalidURL

				case .invalidResponse:
					print("Invalid Response")
					//								alertItem = AlertContext.invalidReponse

				case .invalidData:
					print("Invalid Data")
					//								alertItem = AlertContext.invalidData

				case .unableToComplete:
					print("unableToComplete")
					//								alertItem = AlertContext.invalidToComplete
				}
			}
		} catch {
			print(error)
			return nil
		}
		return nil
	}
}
