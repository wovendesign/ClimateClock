//
//  ContentViewModel.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 02.04.24.
//

import SwiftUI
import Boutique

final class ContentViewModel: ObservableObject {
	
	@Published var climateData: ClimateClockResponse?
	@Published var alertItem: AlertItem?
	@Published var isLoading: Bool = false
	
//	@Stored(in: .newsStore) var news
//	
//	func getClimateData() {
//		isLoading = true
//		NetworkManager.shared.getClimateClockData { result in
//			DispatchQueue.main.async { [self] in
//				isLoading = false
//				switch result {
//					case .success(let data):
//						self.climateData = data
//					try await self._news
//					
//						
//					case .failure(let error):
//						switch error {
//							case .invalidURL:
//								alertItem = AlertContext.invalidURL
//								
//							case .invalidResponse:
//								alertItem = AlertContext.invalidReponse
//								
//							case .invalidData:
//								alertItem = AlertContext.invalidData
//								
//							case .unableToComplete:
//								alertItem = AlertContext.invalidToComplete
//						}
//				}
//			}
//		}
//	}
//	
//	func storeData() {
//		getClimateData()
//		
//	}
}
