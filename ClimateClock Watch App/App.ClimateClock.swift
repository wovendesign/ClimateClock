//
//  App.ClimateClock.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Boutique
import SwiftUI

@main
struct ClimateClock_Watch_App: App {
    @StateObject private var appState = AppState()
    @ObservedObject var newsController = NewsController(store: .newsStore)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    //					appState.$lastAppLaunchTimestamp.set(Date.
                }
        }
        .backgroundTask(.appRefresh("updateClockData")) { _ in
            await newsController.fetchNewsFromAPI()
        }
    }
}
