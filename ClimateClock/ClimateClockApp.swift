//
//  ClimateClockApp.swift
//  ClimateClock
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftData
import SwiftUI

@main
struct ClimateClockApp: App {
	@State var watchConnector = WatchConnector()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.colorScheme(.dark)
				.preferredColorScheme(.dark)
				.environment(watchConnector)
        }
		.modelContainer(for: Idea.self)
    }
}
