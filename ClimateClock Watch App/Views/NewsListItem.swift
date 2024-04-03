//
//  NewsListItem.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 03.04.24.
//

import SwiftUI

struct NewsListItem: View {
	@State var sheetOpen = false
	@ObservedObject var newsController: NewsController
	let newsItem: NewsItem
	
	
	
	var body: some View {
		
		VStack(alignment: .leading) {
			if(newsItem.pushDate != nil) {
				Text(newsItem.pushDate?.formatted(.relative(presentation: .named)) ?? "")
			}
			Text(newsItem.headline)
				.fontDesign(.serif)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			Text(newsItem.source ?? "")
		}
		.padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
		.sheet(isPresented: $sheetOpen) {
			VStack{
				ShareLink(item: newsItem.link!)
			}
		}
		.frame(maxWidth: .infinity)
		.background(Color.white.opacity(0.12))
		.clipShape(.rect(cornerRadius: 18))
		.scrollTransition { content, phase in
			content.scaleEffect(phase.isIdentity ? 1.0 : 0.9)
		}
		.onTapGesture {
			//			guard let url = URL(string: "https://woven.design") else {
			//				return
			//			}
			sheetOpen = true
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		
	}
}

//#Preview {
//	NewsListItem(newsItem: NewsItem(date: "sdf", headline: "Headline", headline_original: "sdf", source: "Reuters", link: "https://google.com", summary: "Some stuff was built", new: false))
//}
