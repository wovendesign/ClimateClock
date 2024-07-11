//
//  ToolbarButton.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 17.06.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct ToolbarButton: View {
	@Environment(Client.self) var client: Client
	@Environment(LocalNotificationManager.self) var localNotificationManager
	@Binding var isShowingSheet: Bool
	
    var body: some View {
		NavigationLink{
			NotificationSettings()
		} label: {
			Image(systemName: localNotificationManager.notificationPermissionGranted ? "bell.badge.fill" : "bell.slash.fill")
							.foregroundStyle(.white)
		}
    }
}

//#Preview {
//	@State var isShowingSheet: Bool = false
//	ToolbarButton(isShowingSheet: $isShowingSheet)
//}
