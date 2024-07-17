//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Eric Wätke on 10.02.24.
//

import UIKit

@Observable public final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()

    static let baseURL = "https://api.climateclock.world/"
    private let clockDataURL = baseURL + "v2/clock.json"
	var retryCount = 0

	init() {}

    func getClimateClockData() async throws -> Result<ClimateClockData, CCError> {
        guard let url = URL(string: clockDataURL) else {
            return .failure(.invalidURL)
        }
		
		do {
			let (task, _) = try await URLSession.shared.data(for: URLRequest(url: url))
			return decodeAPICall(data: task)
		} catch {
			if (retryCount < 5) {
				retryCount += 1
				return try await getClimateClockData()
			}
			
			return .failure(.unableToComplete)
		}
    }
	
	func decodeAPICall(data: Data) -> Result<ClimateClockData, CCError> {
		do {
			let decoder = JSONDecoder()
			let decodedResponse = try decoder.decode(ClimateClockResponse.self, from: data)
			return .success(decodedResponse.data.modules)
		} catch {
			print(error)
			return .failure(.invalidData)
		}
	}
}
