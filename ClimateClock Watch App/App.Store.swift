////
////  App.Store.swift
////  ClimateClock Watch App
////
////  Created by Eric Wätke on 02.04.24.
////
//
//import Boutique
//import Foundation
//
//extension Store where Item == NewsItem {
//    static let newsStore = Store<NewsItem>(
//        storage: SQLiteStorageEngine.default(appendingPath: "News"),
//        cacheIdentifier: \.headline
//    )
//}
//
//final class NewsController: ObservableObject {
//    @Stored var news: [NewsItem]
//
//
//
//    func saveNews(news: [NewsItem]) async throws {
//        // Get the current calendar and today's date
//        let calendar = Calendar.current
//        let today = Date()
//
//        // Get the start of the current week
//        var startOfWeek = Date()
//        var interval = TimeInterval(0)
//        _ = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: today)
//
//        // Get the components of the start of the week
//        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek)
//
//        // Get the date of Monday in the current week
//        guard let monday = calendar.date(from: components) else {
//            print("Failed to get Monday of the current week")
//            return
//        }
//
//        let sortedNews: [NewsItem] = news.enumerated().map {
//            let today: Date = Calendar.current.date(byAdding: .day, value: $0, to: monday) ?? Date()
//            var temp = $1
//            temp.pushDate = today
//
//            var todayComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: today)
//            todayComponents.minute = (todayComponents.minute ?? 0) + 1
//            NotificationManager.instance.scheduleNotification(headline: temp.headline, triggerTime: todayComponents)
//
//            return temp
//        }
//
//        return try await self.$news.insert(sortedNews)
//    }
//
//    func updateNews(oldItem _: NewsItem, newItem: NewsItem) async throws {
//        //		try await self.$news.remove(oldItem)
//        try await $news.insert(newItem)
//    }
//}
