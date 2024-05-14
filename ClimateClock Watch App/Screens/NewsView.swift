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
	@Query(sort: \NewsItem.pushDate) var news: [NewsItem] = []

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(news) { item in
                    NewsListItem(newsItem: item)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.navy, .black]),
                           startPoint: .top,
                           endPoint: .bottom)
                .opacity(1)
        )
        .contentMargins(.vertical, 8, for: .scrollContent)
        .onAppear {
            NotificationManager.instance.requestAuthorization()
        }
    }
}

 #Preview {
	NewsView()
 }
