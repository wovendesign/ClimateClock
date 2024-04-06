//
//  App.State.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 02.04.24.
//

import Boutique
import Foundation

final class AppState: ObservableObject {
	@StoredValue(key: "funkyRedPandaModeEnabled")
	var funkyRedPandaModeEnabled = false

	@StoredValue<Date?>(key: "lastAppLaunchTimestamp")
	var lastAppLaunchTimestamp = nil
}
