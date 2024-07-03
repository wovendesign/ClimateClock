//
//  Countdown.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//
import ClockKit
import SwiftUI

struct CountdownView: View {
    var body: some View {
        VStack {
            Text("Todo: Countdown View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        .background(
            LinearGradient(gradient: Gradient(colors: [.aubergine, .black]),
                           startPoint: .top,
                           endPoint: .bottom)
                .opacity(0.6)
        )
    }
}

#Preview {
    CountdownView()
}
