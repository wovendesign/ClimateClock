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
    var body: some Scene {
        WindowGroup {
            ContentView()
				.colorScheme(.dark)
				.preferredColorScheme(.dark)
        }
		.modelContainer(for: Idea.self)
    }
}
