//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Charts
import SwiftUI

enum Page {
	case lifeline, news, about
}

struct ContentView: View {
    @Environment(Client.self) var client
    @Environment(\.modelContext) var context
	
	private var pages: [Page] = [.lifeline, .news, .about]
	
    var body: some View {
//        TabView {
//			LifelineView()
//				.containerBackground(.lime.gradient, for: .tabView)
//			NewsView()
//				.containerBackground(.navy.gradient, for: .tabView)
//			AboutView()
//				.containerBackground(.navy.gradient, for: .tabView)
//        }
//        .tabViewStyle(.verticalPage)
		NavigationStack {
			List(pages, id: \.self) { page in
				NavigationLinkItem(page: page)
			}
			.listStyle(.carousel)
			.navigationDestination(for: Page.self) { page in
				switch (page) {
				case .news:
					NewsView()
				case .lifeline:
					LifelineView()
				case .about:
					AboutView()
				}
			}
		}
		.task {
			await client.getDataFromClimateClockAPI(context: context)
		}
    }
}

#Preview {
    ContentView()
}
