//
//  Alert.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 02.04.24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

enum AlertContext {
    static let invalidURL = AlertItem(title: Text("Server Error"),
                                      message: Text("Could not reach Server. If this persists, please contact support."),
                                      dismissButton: .default(Text("Try Again")))
    static let invalidReponse = AlertItem(title: Text("Server Error"),
                                          message: Text("Invalid Response from Server. Try again later."),
                                          dismissButton: .default(Text("Try Again")))
    static let invalidData = AlertItem(title: Text("Server Error"),
                                       message: Text("The data received from Server was invalid. Please contact support."),
                                       dismissButton: .default(Text("Try Again")))
    static let invalidToComplete = AlertItem(title: Text("Server Error"),
                                             message: Text("Unable to complete your request at this time. Please check your connection."),
                                             dismissButton: .default(Text("Try Again")))
}
