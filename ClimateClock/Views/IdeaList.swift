//
//  IdeaList.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct IdeaList: View {
	let list: [Idea]
	@State private var searchText: String = ""
	
    var body: some View {
		List(list) { idea in
			Text(idea.idea)
		}
		.searchable(text: $searchText, placement: .navigationBarDrawer)
    }
}

#Preview {
	IdeaList(list: [
		Idea(id: UUID(), status: .approved, date_created: "", idea: "Have a plattform for people to connect and share ideas"),
		Idea(id: UUID(), status: .approved, date_created: "", idea: "Why isnt there a list of upcoming protests")
	])
}
