//
//  App.ClimateClock.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Boutique
import SwiftUI
import SwiftData

@main
struct ClimateClock_Watch_App: App {
    @StateObject private var appState = AppState()
	@State private var client: Client = Client()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
				.environment(client)
        }
		
		.modelContainer(for: [NewsItem.self])
		.backgroundTask(.appRefresh("updateClockData")) { _ in
			
		}
    }
}
