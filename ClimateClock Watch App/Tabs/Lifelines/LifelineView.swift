//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftData
import SwiftUI

struct LifelineColor {
	var foregroundColor: Color
	var backgroundColor: Color
}

struct SelectedLifeLine: Equatable {
	var precision: Int
	var unit: String
	var timestamp: Date
	var lifeLine: LifeLine
	var label: String
	var url: String
}

enum LifeLineLoadingState {
	case loading, error, done
}

struct LifelineView: View {
	@Environment(Client.self) var client: Client
	@Environment(NetworkManager.self) var networkManager: NetworkManager
	@Environment(\.modelContext) var modelContext
	@Query(sort: \LifeLine.order) var lifeLines: [LifeLine]

	@State var sheetOpen = false
	@State var selectedLifeline: SelectedLifeLine?
	@State var loadingState: LifeLineLoadingState = .loading
	@State var errorMessage: String = ""

	let colorGradients: [LifelineColor] = [
		LifelineColor(foregroundColor: Color(red: 170/255, green: 210/255, blue: 255/255),
					  backgroundColor: Color(red: 79/255, green: 102/255, blue: 126/255)),
		LifelineColor(foregroundColor: Color(red: 0.62, green: 0.83, blue: 0.93),
					  backgroundColor: Color(red: 68/255, green: 96/255, blue: 113/255)),
		LifelineColor(foregroundColor: Color(red: 0.58, green: 0.84, blue: 0.85),
					  backgroundColor: Color(red: 0.2, green: 0.35, blue: 0.37)),
		LifelineColor(foregroundColor: Color(red: 0.55, green: 0.85, blue: 0.81),
					  backgroundColor: Color(red: 0.19, green: 0.35, blue: 0.33)),
		LifelineColor(foregroundColor: Color(red: 0.64, green: 0.88, blue: 0.7),
					  backgroundColor: Color(red: 0.26, green: 0.37, blue: 0.31)),
		LifelineColor(foregroundColor: Color(red: 0.71, green: 0.9, blue: 0.62),
					  backgroundColor: Color(red: 0.29, green: 0.39, blue: 0.25)),

		LifelineColor(foregroundColor: Color(red: 0.8, green: 0.93, blue: 0.52),
					  backgroundColor: Color(red: 0.33, green: 0.42, blue: 0.16)),
		LifelineColor(foregroundColor: Color(red: 0.88, green: 0.95, blue: 0.44),
					  backgroundColor: Color(red: 0.4, green: 0.45, blue: 0.13))
	]

	var body: some View {

		ZStack {
			switch loadingState {
			case .loading:
				ProgressView()
					.onAppear {
						Task {
							do {
								let result = try await networkManager.getClimateClockData()

								switch result {
								case let .success(data):
									// Saving LifeLines
									modelContext.insert(client.moduleToLifeline(module: data.ff_divestment_stand_dot_earth,
																				type: .divestment))
									modelContext.insert(client.moduleToLifeline(module: data.indigenous_land_1,
																				type: .indigenous))
									modelContext.insert(client.moduleToLifeline(module: data.loss_damage_g7_debt,
																				type: .g7))
									modelContext.insert(client.moduleToLifeline(module: data.regen_agriculture,
																				type: .agriculture))
									modelContext.insert(client.moduleToLifeline(module: data.renewables_1,
																				type: .renewables))
									modelContext.insert(client.moduleToLifeline(module: data.women_in_parliaments,
																				type: .women))
									loadingState = .done

								case let .failure(error):
									if (loadingState == .done) { return }
									switch error {
									case .invalidURL:
										print("Invalid URL")
										errorMessage = "Invalid URL"

									case .invalidResponse:
										print("Invalid Response")
										errorMessage = "Invalid Response"

									case .invalidData:
										print("Invalid Data")
										errorMessage = "Invalid Data"

									case .unableToComplete:
										print("unableToComplete")
										errorMessage = "Couldn’t get LifeLines. Make sure your Watch is connected to your phone."
									}
									loadingState = .error
								}
							}
							catch {
								if (loadingState == .done) { return }
								errorMessage = error.localizedDescription
								loadingState = .error
							}
						}
					}
			case .error:
				VStack {
					Text(errorMessage)
					Button {
						loadingState = .loading
					} label: {
						Text("Retry")
					}
				}
			case .done:
				List(lifeLines.indices, id: \.self) { index in
					LifeLineCell(lifeLine: lifeLines[index],
								 lifelineColor: (colorGradients.count > index ? colorGradients[index] : colorGradients.last)!,
								 selectedLifeLine: $selectedLifeline)
					.listRowBackground(Color.clear)
					.contentMargins(4, for: .scrollContent)
				}
			}
		}
		.onAppear {
			if (lifeLines.count > 0) {
				loadingState = .done
			}
		}
		.onChange(of: selectedLifeline, { oldValue, newValue in
			if (newValue != nil) {
				sheetOpen = true
			}
		})
		.sheet(isPresented: $sheetOpen, onDismiss: {
			selectedLifeline = nil
		}, content: {
			if let lifeline = selectedLifeline {
				ScrollView {
					VStack(alignment: .leading) {
						LifeLineText(precision: lifeline.precision,
									 unit: lifeline.unit,
									 timestamp: lifeline.timestamp,
									 lifeLine: lifeline.lifeLine)
						Text(lifeline.label)
							.font(
								.custom("Oswald", size: 16)
							)
						Text("https://climateclock.world/science#renewable-energy")
							.font(
								.custom("Assistant", size: 12)
								.weight(.semibold)
							)
							.foregroundStyle(.white)
						if let url = URL(string: lifeline.url) {
							SheetButtonGroup(notificationTitle: "Learn More About",
											 notificationBody: lifeline.label,
											 url: url)
						}
					}
				}
			}
		})
		.containerBackground(.navy.gradient, for: .navigation)
	}
}

#Preview {
	LifelineView()
}
