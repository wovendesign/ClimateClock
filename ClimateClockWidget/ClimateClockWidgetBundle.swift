//
//  ClimateClockWidgetBundle.swift
//  ClimateClockWidget
//
//  Created by Eric Wätke on 15.05.24.
//  Copyright © 2024 woven. All rights reserved.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct ClimateClockWidgetBundle: WidgetBundle {
    var body: some Widget {
//        ClimateClockWidget()
		NewsWidget()
		RenewablesWidget()
    }
}
