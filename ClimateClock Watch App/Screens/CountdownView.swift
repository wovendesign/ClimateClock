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
		let watchFaceUrl = Bundle.main.url(forResource: "Solar Analogue", withExtension: "watchface")
		VStack {
			Text("Todo: Countdown View")
//			Button(action: {
//				//An object for importing watch faces that the app provides
//				let library = CLKWatchFaceLibrary()
//				library.addWatchFace(at: watchFaceUrl!) { (_: Error?) in
//					// Handle the error here
//				}
//			}, label: {
//				Text("Add watchface")
//			})
		}
    }
}

#Preview {
	CountdownView()
}
