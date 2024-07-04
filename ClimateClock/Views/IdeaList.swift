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
						.background(hasVoted ? .blue : .clear)
						.foregroundStyle(hasVoted ? .white : .blue)
				}
				
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
	}
}

#Preview {
	IdeaList(sort: SortDescriptor(\Idea.title), searchString: "")
}
