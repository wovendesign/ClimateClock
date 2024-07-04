//
//  ContentView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI

struct ContentView: View {
	@State var list: [Idea] = []
	@State var errorMessage: String?
	
    var body: some View {
		NavigationStack {
			if let errorMessage = errorMessage {
								Text(errorMessage).foregroundColor(.red)
							}
			IdeaList(list: $list)
			.navigationTitle("Climate Clock")
		}
		.onAppear {
			Task {
				let result = try await NetworkManager.shared.getIdeas()
				switch result {
				case .success(let response):
					print(response.data)
					list = response.data
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
