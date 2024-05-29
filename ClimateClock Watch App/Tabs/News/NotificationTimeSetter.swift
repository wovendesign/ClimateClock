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
    let notificationType: NotificationType
    @Environment(\.modelContext) var context
	@State private var navPath = NavigationPath()

    @Binding var date: Date

    var body: some View {
        VStack {
            DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.hourAndMinute]
            )
        }
        .navigationTitle("Set Time")
    }
}

// #Preview {
//	NotificationTimeSetter(notificationType: .first)
// }
