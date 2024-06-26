//
//  App.ClimateClock.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Sentry
import SwiftData
import SwiftUI

@main
struct ClimateClock_Watch_App: App {
    @AppStorage("first_launch") var firstLaunch: Bool = true

    @State private var client: Client = .init()
	@State private var localNotificationManager: LocalNotificationManager = .init()

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
				.environment(localNotificationManager)
                .onAppear {
                    if firstLaunch {
						firstLaunch = false
						localNotificationManager.setDefaultSchedulingPreferences()
                    }
                }
        }
        .modelContainer(container)
        .backgroundTask(.appRefresh("updateClockData")) { _ in
            let context: ModelContext = .init(container)
			if let data = await client.getDataFromClimateClockAPI(context: context) {
				await localNotificationManager.saveNewsNotifications(news: data, context: context)
			}
        }
    }

    init() {
        SentrySDK.start { options in
            options.dsn = "https://8233dd3afc564e37ba352634dcbd803d@glitchtip.woven.design/3"
            options.debug = false // Enabled debug when first installing is always helpful
            options.enableTracing = true

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
    }
}
