//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Eric Wätke on 10.02.24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()

    static let baseURL = "https://api.climateclock.world/"
    private let clockDataURL = baseURL + "v2/clock.json"

    private init() {}

    func getClimateClockData() async throws -> Result<ClimateClockData, CCError> {
        guard let url = URL(string: clockDataURL) else {
            return .failure(.invalidURL)
        }

        let (task, _) = try await URLSession.shared.data(for: URLRequest(url: url))

        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ClimateClockResponse.self, from: task)
			return .success(decodedResponse.data.modules)
        } catch {
            print(error)
            return .failure(.invalidData)
        }
    }
}
