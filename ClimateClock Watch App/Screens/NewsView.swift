//
//  NewsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//
import AuthenticationServices
import SwiftUI
import Boutique

struct NewsView: View {
	@State var news: [NewsItem] = []
	@EnvironmentObject private var newsController: NewsController
	
	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(news) { item in
					NewsListItem(newsController: newsController, newsItem: item)
				}
			}
		}
		.frame(maxWidth: .infinity)
		.background(
			LinearGradient(gradient: Gradient(colors: [Color(red: 0.031372549, green: 0.1882352941, blue: 0.3058823529), .black]),
						   startPoint: .top,
						   endPoint: .bottom)
			.opacity(1)
		)
		.contentMargins(.vertical, 8, for: .scrollContent)
//		.onReceive(news, perform: {
//			self.news = $0
//		})
		.onReceive(self.newsController.$news.$items, perform: {
			self.news = $0.sorted(by: {$0.pushDate ?? Date() > $1.pushDate ?? Date()}).filter{$0.pushDate?.distance(to: Date()) ?? 0 > 0}
		})
	}
}

//#Preview {
//	NewsView()
//}
