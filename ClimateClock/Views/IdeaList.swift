//
//  IdeaList.swift
//  ClimateClock
//
//  Created by Eric Wätke on 04.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftData
import SwiftUI

struct IdeaList: View {
	@Environment(\.modelContext) var modelContext
	@Query var ideas: [Idea]
	var searchText: String = ""
	
	var body: some View {
		List(ideas) { idea in
			let hasVoted = idea.votes.contains{ $0.uuidString == UIDevice.current.identifierForVendor!.uuidString }
			HStack {
				VStack(alignment: .leading) {
					Text(idea.date_created.formatted(.relative(presentation: .named, unitsStyle: .wide)))
					Text(idea.title)
						.bold()
					Text(idea.idea)
				}
				
				Spacer()
				
				Button {
					
				} label: {
					Text("\(idea.votes.count) +")
						.padding(.horizontal, 6)
						.padding(.vertical, 2)
						.background(hasVoted ? .aquaBlue : .clear)
						.clipShape(.rect(cornerRadius: 20))
						.foregroundStyle(hasVoted ? .white : .blue)
				}
				
			}
		}
		.onAppear {
			print(ideas)
		}
		.overlay {
			if ideas.isEmpty, !searchText.isEmpty {
				/// In case there aren't any search results, we can
				/// show the new content unavailable view.
				ContentUnavailableView.search
			}
		}
	}
	
	init(sort: SortDescriptor<Idea>, searchString: String) {
		_ideas = Query(filter: #Predicate {
			if searchString.isEmpty {
				return true
			} else {
				return $0.title.localizedStandardContains(searchString) || $0.idea.localizedStandardContains(searchString)
			}
		}, sort: [sort])
		self.searchText = searchString
	}
}

#Preview {
	IdeaList(sort: SortDescriptor(\Idea.title), searchString: "")
}
