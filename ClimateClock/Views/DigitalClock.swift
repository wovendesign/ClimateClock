//
//  DigitalClock.swift
//  ClimateClock
//
//  Created by Eric Wätke on 04.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI

struct DigitalClock: View {
	var body: some View {
//		WebView(url: URL(string: "https://digital.cclock.org")!)
		WebView(url: URL(string: "https://woven.design")!)
			.edgesIgnoringSafeArea(.all)
			.preferredColorScheme(.dark)
			.colorScheme(.dark)
	}
}

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	let url: URL
	
	func makeUIView(context: Context) -> WKWebView  {
		let wkwebView = WKWebView()
		let request = URLRequest(url: url)
		wkwebView.load(request)
		wkwebView.backgroundColor = .black
		let cssString = "body: {background: #000;}.sc-evZas.gioIeC {background: blue;}"
		let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
		wkwebView.evaluateJavaScript(jsString, completionHandler: nil)
		return wkwebView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
	}
}
