//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
import Charts

struct ContentView: View {
	@StateObject var viewModel = ContentViewModel()
	@ObservedObject var newsController = NewsController(store: .newsStore)

	
    var body: some View {
		TabView {
			CountdownView()
			GraphView()
			FiguresView()
			NewsView()
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
