//
//  NewsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//
import AuthenticationServices
import SwiftUI
import SwiftData

struct NewsView: View {
	static var now: Date { Date.now }
	@Query(filter: #Predicate<NewsItem> {$0.pushDate ?? now < now},
		   sort: \NewsItem.pushDate,
		   order: .reverse
	)
	var news: [NewsItem] = []

    var body: some View {
		TabTitleLayout(
			headline: "Newsfeed of Hope",
			subtitle: "Daily news of recent climate victories.") {
			ScrollView {
				LazyVStack {
					ForEach(news, id: \.id) { item in
						NewsListItem(newsItem: item)
					}
				}
			}
			.contentMargins(.vertical, 8, for: .scrollContent)
		}
        .background(
            LinearGradient(gradient: Gradient(colors: [.navy, .black]),
                           startPoint: .top,
                           endPoint: .bottom)
        )
        .onAppear {
			print(news.count)
            NotificationManager.instance.requestAuthorization()
			
			let date = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
			guard let date else {
				print("Couldnt get date")
				return 
			}
			let dateComponents: DateComponents = Calendar.current.dateComponents([.day, .month, .hour, .minute], from: date)
			
			if let firstNews = news.first {
				NotificationManager.instance.scheduleNotification(news: firstNews,
																  triggerTime: dateComponents)
			}
        }
    }
}

 #Preview {
	NewsView()
 }
