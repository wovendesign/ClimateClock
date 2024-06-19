//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import Charts
import SwiftUI

enum Page {
	case lifeline, news, about, deadline
}

struct ContentView: View {
    @Environment(Client.self) var client
    @Environment(\.modelContext) var context
	
	private var pages: [Page] = [.lifeline, .deadline, .news, .about]
	
    var body: some View {
		NavigationStack {
			List {
				TabTitle(headline: "Climate Clock", subtitle: "")
				Section {
					ForEach(pages, id:  \.self) { page in
						NavigationLinkItem(page: page)
					}
				}
			}
			.navigationDestination(for: Page.self) { page in
				switch (page) {
				case .news:
					NewsView()
				case .lifeline:
					LifelineView()
				case .about:
					AboutView()
				case .deadline:
					Text("Deadline")
						.containerBackground(Color.ccRed50.gradient, for: .navigation)
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
