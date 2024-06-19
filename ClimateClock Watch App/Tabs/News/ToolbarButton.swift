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
	@Binding var isShowingSheet: Bool
	
    var body: some View {
//		Button {
//			client.notificationPermissionGranted ? isShowingSheet.toggle() : client.requestNotificationPermissions()
//		} label: {
//			Image(systemName: client.notificationPermissionGranted ? "bell.badge.fill" : "bell.slash.fill")
//				.foregroundStyle(.white)
//		}
//		.sheet(isPresented: $isShowingSheet, onDismiss: {
//			isShowingSheet = false
//		}) {
//			NotificationSettings()
//				.background(.black)
//		}
		NavigationLink{
			NotificationSettings()
		} label: {
			Image(systemName: client.notificationPermissionGranted ? "bell.badge.fill" : "bell.slash.fill")
							.foregroundStyle(.white)
		}
    }
}

#Preview {
	@State var isShowingSheet: Bool = false
	ToolbarButton(isShowingSheet: $isShowingSheet)
}
