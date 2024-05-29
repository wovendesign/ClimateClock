//
//  App.ClimateClock.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftData
import SwiftUI

@main
struct ClimateClock_Watch_App: App {
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
        }

        .modelContainer(container)
        .backgroundTask(.appRefresh("updateClockData")) { _ in
            let context: ModelContext = .init(container)
            await client.getDataFromClimateClockAPI(context: context)
        }
    }
}
