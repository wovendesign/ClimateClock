//
//  AboutView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 01.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct AboutView: View {
	enum AboutSheet {
		case woven, cclock
	}
	@State var sheetOpen = false
	@State var sheetContent: AboutSheet = .cclock
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Text("About the Climate Clock WatchOS App")
					.applyHeadlineStyle(.Section_Bold)
				
				VStack(alignment: .leading) {
					HStack(alignment: .center) {
						Spacer()
						Image("climateclock-logo")
							.resizable()
							.frame(width: 24, height: 24)
						Text("Climate Clock")
						  .font(Font.custom("Oswald", size: 14))
						  .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
						Spacer()
					}
					
					HighlightedText(text: "Join the Climate Clock Community. ClimateClock.world\n\n#ClimateClock #ActInTime",
									highlighted: "ClimateClock.world",
									highlightColor: .red)
				}
				.onTapGesture {
					sheetOpen = true
					sheetContent = .cclock
				}
				
				VStack(alignment: .leading) {
					Text("Development")
						.applyHeadlineStyle(.Section)
						.bold()
						.foregroundColor(Color(red: 0.95, green: 0.96, blue: 0.99))
					HighlightedText(text: "This app was designed and developed by woven.\nwoven.design",
									highlighted: "woven.design",
									highlightColor: .red)
				}
				.onTapGesture {
					sheetOpen = true
					sheetContent = .woven
				}
				.sheet(isPresented: $sheetOpen) {
					ScrollView {
						switch sheetContent {
						case .cclock :
							Text("ClimateClock.world")
								.applyTextStyle(.Paragraph)
							VStack(alignment: .leading) {
								SheetButtonGroup(notificationTitle: "Join the Climate Clock Community",
												 notificationBody: "ClimateClock.world",
												 url: URL(string: "ClimateClock.world")!)
							}
						case .woven:
							Text("woven.design")
								.applyTextStyle(.Paragraph)
							VStack(alignment: .leading) {
								SheetButtonGroup(notificationTitle: "Who’s woven?",
												 notificationBody: "A design & development studio with a focus on user interfaces and websites that spark joy.",
												 url: URL(string: "https://woven.design")!)
							}
						}
					}
				}
			}
			.padding(.horizontal, 4)
		}
		.containerRelativeFrame(.horizontal)
	}
}
