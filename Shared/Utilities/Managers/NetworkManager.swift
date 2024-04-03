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
		
//			if(error != nil) {
//				completed(.failure(.unableToComplete))
//				return
//			}
//			
//			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//				completed(.failure(.invalidResponse))
//				return
//			}
//			
//			guard let data = data else {
//				completed(.failure(.invalidData))
//				return
//			}
		
		do {
			let decoder = JSONDecoder()
			let decodedResponse = try decoder.decode(ClimateClockResponse.self, from: task)
			return .success(decodedResponse)
		} catch {
			return .failure(.invalidData)
		}
	}
	
	
//	func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> ()) {
//		let cacheKey = NSString(string: urlString)
//		
//		if let image = cache.object(forKey: cacheKey) {
//			completed(image)
//			return
//		}
//		
//		guard let url = URL(string: urlString) else {
//			completed(nil)
//			return
//		}
//		
//		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//			guard let data = data, let image = UIImage(data: data) else {
//				completed(nil)
//				return
//			}
//			
//			self.cache.setObject(image, forKey: cacheKey)
//			
//			completed(image)
//		}
//		
//		task.resume()
//	}
}
