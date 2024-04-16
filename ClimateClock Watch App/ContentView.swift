//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Charts
import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = ContentViewModel()
	@StateObject var newsController = NewsController(store: .newsStore)

	var body: some View {
		TabView {
			CountdownView()
			GraphView()
			NewsView()
				.environmentObject(newsController)
			LifelineView()
			AboutView()
		}
		.tabViewStyle(.verticalPage)
		.task {
//			viewModel.getClimateData()
			print(await newsController.fetchNewsFromAPI())
		}
	}
}

#Preview {
	ContentView()
}
