//
//  AddIdeaSheet.swift
//  ClimateClock
//
//  Created by Eric Wätke on 04.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

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
