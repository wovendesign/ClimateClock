//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Charts
import SwiftUI

struct ContentView: View {
    @Environment(Client.self) var client
    @Environment(\.modelContext) var context

    var body: some View {
        TabView {
            LifelineView()

            //            CountdownView()
            //            GraphView()
            NewsView()

            AboutView()
        }
        .tabViewStyle(.verticalPage)
        .task {
            await client.getDataFromClimateClockAPI(context: context)
        }
    }
}

#Preview {
    ContentView()
}
