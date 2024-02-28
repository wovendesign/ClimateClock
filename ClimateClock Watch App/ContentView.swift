//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
import Charts

struct ContentView: View {
    var body: some View {
		TabView {
			CountdownView()
			GraphView()
			FiguresView()
			AboutView()
		}
		.tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView()
}
