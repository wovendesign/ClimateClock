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

    func getClimateClockData() async throws -> Result<ClimateClockResponse, CCError> {
        guard let url = URL(string: clockDataURL) else {
            return .failure(.invalidURL)
        }

        let (task, _) = try await URLSession.shared.data(for: URLRequest(url: url))

        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ClimateClockResponse.self, from: task)
            return .success(decodedResponse)
        } catch {
            print(error)
            return .failure(.invalidData)
        }
    }
	
	static let directusURL = "https://directus.woven.design/"
	private let ideasURL = directusURL + "https://directus.woven.design/items/climateclock_ios_feedback"
	
	func getIdeas() async throws -> Result<DirectusResponse, CCError> {
		guard let url = URL(string: ideasURL) else {
		  return .failure(.invalidURL)
		}
		
		var request = URLRequest(url: url)

		let (task, _) = try await URLSession.shared.data(for: URLRequest(url: url))

		do {
		  let decoder = JSONDecoder()
			let decodedResponse = try decoder.decode(DirectusResponse.self, from: task)
		  return .success(decodedResponse)
		} catch {
		  print(error)
		  return .failure(.invalidData)
		}
	}
	
	func submitIdea() async throws -> Result<Int, CCError> {
		guard let url = URL(string: ideasURL) else {
		  return .failure(.invalidURL)
		}
		
		let json: [String: Any] = ["title": "ABC",
								   "dict": ["1":"First", "2":"Second"]]

		let jsonData = try? JSONSerialization.data(withJSONObject: json)
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		
		let (task, _) = try await URLSession.shared.data(for: URLRequest(url: url))

		do {
		  let decoder = JSONDecoder()
			let decodedResponse = try decoder.decode(DirectusResponse.self, from: task)
		  return .success(1)
		} catch {
		  print(error)
		  return .failure(.invalidData)
		}
	}
}
