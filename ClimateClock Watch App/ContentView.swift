//
//  ContentView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 05.01.24.
//

import SwiftUI
func parseDateString(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter.date(from: dateString)
}
func dateDiff(deadline: Date, now: Date) -> DateComponents {
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year, .day, .hour, .minute, .second], from: now, to: deadline)
    
    return components
}
func get_data() -> Void{
    let url = URL(string: "https://api.climateclock.world/v2/widget/clock.json")!
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
    
    var clock_data: ClimateClockData?

    print("test")
    
    URLSession.shared.dataTask(with: request) {(data, response, error) in
        guard let data = data else {
            print("brrr")
            return
        }
        
        do {
            guard let json = String(data: data, encoding: .utf8) else { return }
            clock_data = parseJSON(json: json)
            
            print(clock_data)
            if let parsedDate = (clock_data?.modules.carbonDeadlines) {
                if let deadline = parseDateString(parsedDate.timestamp) {
                   
                    
                    print("diff ", deadline)
                } else {
                    print("noon")
                }
            } else { print("sdf") }
        }
    }.resume()
    }

struct ContentView: View {
    var body: some View {
        let _ = get_data()
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! This is my app")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
