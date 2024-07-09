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
	private let ideasURL = directusURL + "items/climateclock_ios_feedback?fields[]=*&fields[]=votes.device_identifier"
	
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
	
	
	func submitIdea(idea: InsertableIdea) async throws -> Result<UUID, CCError> {
	 guard let url = URL(string: ideasURL) else {
		 return .failure(.invalidURL)
	 }
	 
	 let jsonData = try JSONEncoder().encode(idea)
	 
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.httpBody = jsonData
	 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 do {
		 let (data, response) = try await URLSession.shared.data(for: request)
		 
		 // Check if the response is an HTTP response and has a valid status code
		 if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
			 if let jsonString = String(data: data, encoding: .utf8) {
				 print("Server error response: \(jsonString)")
			 }
			 return .failure(.invalidResponse)
		 }
		 
		 // Decode response
		 let decoder = JSONDecoder()
		 let decodedResponse = try decoder.decode(DirectusIdeaInsertResponse.self, from: data)
		 return .success(decodedResponse.data.id)
	 } catch {
		 print("Decoding error: \(error)")
		 return .failure(.invalidData)
	 }
 }
}
