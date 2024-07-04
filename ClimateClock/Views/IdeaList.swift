//
//  IdeaList.swift
//  ClimateClock
//
//  Created by Eric Wätke on 03.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct IdeaList: View {
	@State var list: [Idea]
	@State private var searchText: String = ""
	@State private var showingSheet = false
	
	
	var filteredList: [Idea] {
		guard !searchText.isEmpty else { return list }
		return list.filter { $0.idea.localizedCaseInsensitiveContains(searchText) }
	}
	
	var body: some View {
		VStack {
			List(filteredList) { idea in
				Text(idea.idea)
			}
			.searchable(text: $searchText, placement: .navigationBarDrawer)
			.sheet(isPresented: $showingSheet, content: ExampleSheet.init)
			
			Spacer()
			
			Button {
				showingSheet = true
			} label: {
				Text("Propose your own Idea")
			}
			
		}
	}
}

struct ExampleSheet: View {
	@Environment(\.dismiss) var dismiss
	@State var title: String = ""
	@State var description: String = ""
	
	var body: some View {
		NavigationStack {
			VStack {
				Form {
					Section(header: Text("Title")) {
						TextField("Your idea in a few words", text: $title)
					}
					
					Section(header: Text("Description"), footer: Text("0/255")) {
						TextField("Describe your idea …", text: $description, axis: .vertical)
										.lineLimit(2...)
//						TextEditor(text: $description)
					}
				}
				
			}
			.navigationTitle("Your Idea")
			.toolbar(content: {
				ToolbarItem(placement: .topBarLeading) {
					Button {
						dismiss()
					} label: {
						Text("Cancel")
					}
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
						Task {
							let idea = InsertableIdea(title: title, 
													  idea: description,
													  device_identifier: UIDevice.current.identifierForVendor!.uuidString)
							do {
								let res = try await NetworkManager.shared.submitIdea(idea: idea)
								print (res)
							} catch {
								print(error)
							}
						}
					} label: {
						Text("Send")
					}
				}
			})
		}
	}
}

#Preview {
	IdeaList(list: [
		Idea(id: UUID(), status: .approved, date_created: "", title: "Forum", idea: "Have a plattform for people to connect and share ideas", device_identifier: UIDevice.current.identifierForVendor!.uuidString),
		Idea(id: UUID(), status: .approved, date_created: "", title: "Upcoming Protests", idea: "Why isnt there a list of upcoming protests", device_identifier: UIDevice.current.identifierForVendor!.uuidString)
	])
}
