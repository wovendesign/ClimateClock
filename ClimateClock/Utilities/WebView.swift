//
//  WebView.swift
//  ClimateClock
//
//  Created by Eric Wätke on 10.07.24.
//  Copyright © 2024 woven. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	// 1
	let url: URL

	
	// 2
	func makeUIView(context: Context) -> WKWebView {

		return createWebView()
	}
	
	// 3
	func updateUIView(_ webView: WKWebView, context: Context) {

		let request = URLRequest(url: url)
		webView.load(request)
	}
	
	// Helper function to create WKWebView with CSS injection
		private func createWebView() -> WKWebView {
			let webViewConfiguration = WKWebViewConfiguration()
			
			let cssString = "body { background-color: #1C1C1E; }"
			
			// Create a WKUserScript to inject CSS
			let cssScript = """
			var style = document.createElement('style');
			style.innerHTML = '\(cssString)';
			document.head.appendChild(style);
			"""
			let userScript = WKUserScript(source: cssScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
			
			// Create a WKUserContentController and add the user script
			let userContentController = WKUserContentController()
			userContentController.addUserScript(userScript)
			
			webViewConfiguration.userContentController = userContentController
			
			return WKWebView(frame: .zero, configuration: webViewConfiguration)
		}
}
