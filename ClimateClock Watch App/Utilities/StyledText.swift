////
////  StyledText.swift
////  ClimateClock
////
////  Created by Eric Wätke on 10.07.24.
////  Copyright © 2024 woven. All rights reserved.
////
//
//import SwiftUI
//
//enum TextStyle {
//	case Footnote_Emphasized, Footnote_Default, Label, Label_Emphasized, Label_Button, Paragraph, Paragraph_Bold, Paragraph_Highlighted
//}
//
//enum HeadlineStyle {
//	case Section, Section_Bold, Section_Bold_Wider, Lifeline_Figure
//}
//
//struct StyledText: View {
//	let text: String
//	let textStyle: TextStyle?
//	let headlineStyle: HeadlineStyle?
//	
//	init(text: String, textStyle: TextStyle?) {
//		self.text = text
//		self.textStyle = textStyle
//		self.headlineStyle = nil
//	}
//	
//	init(text: String, headlineStyle: HeadlineStyle?) {
//		self.text = text
//		self.textStyle = nil
//		self.headlineStyle = headlineStyle
//	}
//	
//    var body: some View {
//		if let textStyle = textStyle {
//			switch textStyle {
//			case .Footnote_Emphasized:
//				Text(text)
//					.font(
//						.custom("Oswald", size: 10)
//					)
//					.textCase(.uppercase)
//					.tracking(0.2)
//					.environment(\._lineHeightMultiple, 0.8)
//			case .Footnote_Default:
//				Text(text)
//					.font(
//						.custom("Assistant", size: 10)
//							.weight(.semibold)
//					)
//			case .Label:
//				Text(text)
//					.font(
//						.custom("Assistant", size: 12)
//							.weight(.semibold)
//					)
//			case .Label_Emphasized:
//				Text(text)
//					.font(
//						.custom("Oswald", size: 12)
//						.weight(.regular)
//					)
//			case .Label_Button:
//				Text(text)
//					.font(
//						.custom("Assistant", size: 16)
//							.weight(.semibold)
//					)
//			case .Paragraph:
//				Text(text)
//					.font(
//						.custom("Assistant", size: 16)
//						.weight(.regular)
//					)
//			case .Paragraph_Bold:
//				Text(text)
//					.font(
//						.custom("Assistant", size: 16)
//						.weight(.semibold)
//					)
//			case .Paragraph_Highlighted:
//				Text(text)
//					.font(
//						.custom("Oswald", size: 16)
//							.weight(.regular)
//					)
//					.tracking(0.32)
//			}
//		}
//		if let headlineStyle = headlineStyle {
//			switch headlineStyle {
//			case .Section:
//				Text(text)
//					.font(
//						.custom("Oswald", size: 16)
//						.weight(.regular)
//					)
//					.tracking(0.32)
//			case .Section_Bold:
//				<#code#>
//			case .Lifeline_Figure:
//				<#code#>
//			}
//		}
//    }
//}
//
//#Preview {
//	StyledText(text: "Hello, World!", headlineStyle: .Section)
//}
//
//

import SwiftUI

enum TextStyle {
	case Footnote_Emphasized, Footnote_Default, Label, Label_Emphasized, Label_Button, Paragraph, Paragraph_Bold, Paragraph_Highlighted
}

enum HeadlineStyle {
	case Section, Section_Bold, Lifeline_Figure
}

extension Text {
	func applyTextStyle(_ style: TextStyle) -> Text {
		switch style {
		case .Footnote_Emphasized:
			return self.font(.custom("Oswald", size: 10)).tracking(0.2)
		case .Footnote_Default:
			return self.font(.custom("Assistant", size: 10).weight(.semibold))
		case .Label:
			return self.font(.custom("Assistant", size: 12).weight(.semibold))
		case .Label_Emphasized:
			return self.font(.custom("Oswald", size: 12).weight(.regular))
		case .Label_Button:
			return self.font(.custom("Assistant", size: 16).weight(.semibold))
		case .Paragraph:
			return self.font(.custom("Assistant", size: 16).weight(.regular))
		case .Paragraph_Bold:
			return self.font(.custom("Assistant", size: 16).weight(.semibold))
		case .Paragraph_Highlighted:
			return self.font(.custom("Oswald", size: 16).weight(.regular)).tracking(0.32)
		}
	}
	
	func applyHeadlineStyle(_ style: HeadlineStyle) -> Text {
		switch style {
		case .Section:
			return self.font(.custom("Oswald", size: 16).weight(.regular)).tracking(0.32)
		case .Section_Bold:
			return self.font(.custom("Oswald", size: 18).weight(.semibold)).tracking(0.32)
		case .Lifeline_Figure:
			return self.font(.custom("Oswald", size: 20).weight(.bold)).tracking(0.32)
		}
	}
}

struct StyledText_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Text("Hello, World!").applyTextStyle(.Footnote_Emphasized)
			Text("Hello, World!").applyTextStyle(.Footnote_Default)
			Text("Hello, World!").applyTextStyle(.Label)
			Text("Hello, World!").applyTextStyle(.Label_Emphasized)
			Text("Hello, World!").applyTextStyle(.Label_Button)
			Text("Hello, World!").applyTextStyle(.Paragraph)
			Text("Hello, World!").applyTextStyle(.Paragraph_Bold)
			Text("Hello, World!").applyTextStyle(.Paragraph_Highlighted)
			Text("Hello, World!").applyHeadlineStyle(.Section)
			Text("Hello, World!").applyHeadlineStyle(.Section_Bold)
			Text("Hello, World!").applyHeadlineStyle(.Lifeline_Figure)
		}
		.padding()
	}
}
