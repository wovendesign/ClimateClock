//
//  ClimateClockWidgets.swift
//  ClimateClockWidgets
//
//  Created by Eric Wätke on 17.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftData
import SwiftUI
import WidgetKit

@main
struct WatchWidgetBundle: WidgetBundle {
	var body: some Widget {
		NewsWidget()
		RenewablesWidget()
		DeadlineWidget()
	}
}
