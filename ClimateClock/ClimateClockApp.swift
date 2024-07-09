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
	@State var lnManager = LocalNotificationManager()
	@State var watchConnector = WatchConnector()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.colorScheme(.dark)
				.preferredColorScheme(.dark)
				.environment(watchConnector)
				.environment(lnManager)
        }
		.modelContainer(for: Idea.self)
    }
}
