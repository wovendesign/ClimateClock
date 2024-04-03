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
	@Stored(in: .newsStore) var news: [NewsItem]
	
	var body: some View {
		ScrollView {
			VStack {
				ForEach(news) { item in
					NewsListItem(newsItem: item)
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
		.scrollTargetBehavior(.viewAligned)
	}
}

//#Preview {
//	NewsView()
//}
