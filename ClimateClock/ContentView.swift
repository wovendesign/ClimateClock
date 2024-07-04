//
//  ContentView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) var modelContext
	@Query var ideas: [Idea]
	
	@State var errorMessage: String?
	
    var body: some View {
		NavigationStack {
			if let errorMessage = errorMessage {
								Text(errorMessage).foregroundColor(.red)
							}
			IdeaListView()
			.navigationTitle("Climate Clock")
		}
		.onAppear {
			Task {
				do {
					try modelContext.delete(model: Idea.self)
				} catch {
					print("Failed to clear all Country and City data.")
				}
				let result = try await NetworkManager.shared.getIdeas()
				switch result {
				case .success(let response):
					for idea in response.data {
						modelContext.insert(idea)
					}
				case .failure(let error):
					errorMessage = error.localizedDescription
				}
			}
		}
    }
}
//
//#Preview {
//    ContentView()
//}
