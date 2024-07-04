//
//  IdeaList.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftData
import SwiftUI

struct IdeaListView: View {
	@Environment(\.modelContext) var modelContext

	@State private var showingSheet = false
	@State private var sortOrder = SortDescriptor(\Idea.title)
	@State private var searchText: String = ""
	
	var body: some View {
		VStack {
			IdeaList(sort: sortOrder, searchString: searchText)
			.searchable(text: $searchText)
			.sheet(isPresented: $showingSheet, content: ExampleSheet.init)
			
			Spacer()
			
			Button {
				showingSheet = true
			} label: {
				Text("Propose your own Idea")
			}
			
		}
		.toolbar {
				Button {
					showingSheet = true
				} label: {
					Image(systemName: "lightbulb")
				}
			Menu("Sort", systemImage: "arrow.up.arrow.down") {
				Picker("Sort", selection: $sortOrder) {
					Text("Name")
						.tag(SortDescriptor(\Idea.title))
					Text("Date")
						.tag(SortDescriptor(\Idea.date_created))
//					Text("Votes")
//						.tag(SortDescriptor(\Idea.))
				}
				.pickerStyle(.inline)
			}
		}
	}
}


//#Preview {
//	IdeaList(list: [
//		Idea(id: UUID(), status: .approved, date_created: "", title: "Forum", idea: "Have a plattform for people to connect and share ideas", device_identifier: UIDevice.current.identifierForVendor!.uuidString),
//		Idea(id: UUID(), status: .approved, date_created: "", title: "Upcoming Protests", idea: "Why isnt there a list of upcoming protests", device_identifier: UIDevice.current.identifierForVendor!.uuidString)
//	])
//}
