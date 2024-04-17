//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Charts
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var newsController = NewsController(store: .newsStore)

    var body: some View {
        TabView {
            NavigationStack {
                LifelineView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                print("I pressed something")
                            } label: {
                                Image(systemName: "info.circle.fill")
                                    .foregroundStyle(.white)
                            }
                            .controlSize(.mini)
                        }
                    }
            }
            CountdownView()
            GraphView()
            NewsView()
                .environmentObject(newsController)

            AboutView()
        }
        .tabViewStyle(.verticalPage)
        .task {
            await newsController.fetchNewsFromAPI()
        }
    }
}

#Preview {
    ContentView()
}
