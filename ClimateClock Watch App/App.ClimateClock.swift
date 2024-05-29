//
//  App.ClimateClock.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftData
import SwiftUI
import Sentry

@main
struct ClimateClock_Watch_App: App {
    init() {
        SentrySDK.start { options in
            options.dsn = "https://8233dd3afc564e37ba352634dcbd803d@glitchtip.woven.design/3"
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true 

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
    }
	@AppStorage("first_launch") var firstLaunch: Bool = true
	
	
    @State private var client: Client = .init()

    // SwiftData Container
    let container: ModelContainer = {
        let schema = Schema([NewsItem.self, LifeLine.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(client)
				.onAppear {
					if firstLaunch {
						firstLaunch = false
						client.setDefaultSchedulingPreferences()
					}
				}
        }
        .modelContainer(container)
        .backgroundTask(.appRefresh("updateClockData")) { _ in
            let context: ModelContext = .init(container)
            await client.getDataFromClimateClockAPI(context: context)
        }
    }
}
