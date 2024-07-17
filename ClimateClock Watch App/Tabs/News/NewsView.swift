//
//  NewsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//
import AuthenticationServices
import SwiftData
import SwiftUI
import WatchKit

struct SelectedNews: Equatable {
	let newsItem: NewsItem
	let url: URL
}

enum NewsLoadingState {
	case loading, error, done
}


struct NewsView: View {
	static var now: Date { Date.now }
	
	@Query(filter: #Predicate<NewsItem> { $0.pushDate ?? now < now },
		   sort: \NewsItem.pushDate,
		   order: .reverse)
	var news: [NewsItem]
	
	@Environment(Client.self) var client: Client
	@Environment(\.modelContext) var modelContext
	@Environment(LocalNotificationManager.self) var localNotificationManager: LocalNotificationManager
	@Environment(NetworkManager.self) var networkManager: NetworkManager
	@State var sheetOpen = false
	@State var selectedNews: SelectedNews?
	@State var loadingState: NewsLoadingState = .loading
	@State var errorMessage: String = ""
	
	var body: some View {
		ZStack {
			switch loadingState {
			case .loading:
				ProgressView()
					.onAppear{
						Task {
							do {
								let result = try await networkManager.getClimateClockData()
								
								switch result {
								case .success(let success):
									await localNotificationManager.saveNewsNotifications(news: success.newsfeed_1.newsfeed,
																				 context: modelContext)
								case .failure(let failure):
									errorMessage = failure.localizedDescription
									loadingState = .error
								}
							} catch {
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
				List(news) { item in
					NewsListItem(newsItem: item, selectedNews: $selectedNews)
				}
			}
		}
		.padding(.horizontal, 4)
		.containerBackground(.lime.gradient, for: .navigation)
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				NavigationLink(value: "notificationSettings") {
					Image(systemName: localNotificationManager.notificationPermissionGranted ? "bell.badge.fill" : "bell.slash.fill")
									.foregroundStyle(.white)
				}
			}
		}
		.onChange(of: selectedNews, { oldValue, newValue in
			if (newValue != nil) {
				sheetOpen = true
			}
		})
		.sheet(isPresented: $sheetOpen, onDismiss: {
			selectedNews = nil
		}, content: {
			if let news = selectedNews {
				ScrollView {
					VStack(alignment: .leading) {
						Text(news.newsItem.headline)
							.applyTextStyle(.Paragraph_Highlighted)
						
						if let source = news.newsItem.source {
							Text(source)
								.applyTextStyle(.Label)
								.foregroundStyle(Color.white)
								
						}
						SheetButtonGroup(notificationTitle: "Read News of Hope",
										 notificationBody: news.newsItem.headline,
										 url: news.url)
					}
				}
			}
		})
		.onAppear {
			if (news.count > 0) {
				loadingState = .done
			}
			Task {
				await localNotificationManager.getCurrentSettings()
			}
		}
	}
}
