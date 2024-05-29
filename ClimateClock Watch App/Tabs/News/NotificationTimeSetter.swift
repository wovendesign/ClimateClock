//
//  NotificationTimeSetter.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 29.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftData
import SwiftUI

struct NotificationTimeSetter: View {
    let notificationType: Client.NotificationType
    //	@Query var scheduling_preferences: [SchedulingPreferences]?
    @Environment(\.modelContext) var context

    @Binding var date: Date
    @State private var temp_date: Date = .now

    var body: some View {
        VStack {
            DatePicker(
                "Start Date",
                selection: $temp_date,
                displayedComponents: [.hourAndMinute]
            )
            Button {
                date = temp_date
            } label: {
                Text("Done")
            }
        }
        .onAppear {
            temp_date = date
        }
        .navigationTitle("Set Time")
    }
}

// #Preview {
//	NotificationTimeSetter(notificationType: .first)
// }
