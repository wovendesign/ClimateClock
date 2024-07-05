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
	@State private var sortField = SortDescriptor<Idea>(\Idea.title)
	@State private var sortOrder: SortOrder = .forward
	@State private var searchText: String = ""
	
	var body: some View {
		VStack {
			IdeaList(sort: sortField, searchString: searchText)
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
			Menu("Sort", systemImage: "arrow.up.arrow.down") {
				Picker("Sort Direction", selection: $sortOrder) {
					Image(systemName: "arrow.down.to.line").tag(SortOrder.forward)
					Image(systemName: "arrow.up.to.line").tag(SortOrder.reverse)
				}
				.pickerStyle(.segmented)
				.onChange(of: sortOrder) { oldValue, newValue in
					switch sortField.keyPath {
					case \Idea.title:
						print("was on title")
						sortField = SortDescriptor(\Idea.title, order: newValue)
						
					case \Idea.date_created:
						print("was on date")
						sortField = SortDescriptor(\Idea.date_created, order: newValue)
						
					case \Idea.votes.count:
						print("was on vote")
						sortField = SortDescriptor(\Idea.votes.underestimatedCount, order: newValue)
						
					default:
						sortField = SortDescriptor(\Idea.title, order: newValue)
					}
				}
				
				Picker("Sort", selection: $sortField) {
					Text("Name")
						.tag(SortDescriptor(\Idea.title, order: sortOrder))
					Text("Date")
						.tag(SortDescriptor(\Idea.date_created, order: sortOrder))
					Text("Votes")
						.tag(SortDescriptor(\Idea.votes.underestimatedCount, order: sortOrder))
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
