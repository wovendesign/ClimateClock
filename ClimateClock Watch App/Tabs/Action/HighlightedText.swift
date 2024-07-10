//
//  HighlightedText.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 15.05.24.
//

import SwiftUI

struct HighlightedText: View {
    let text: String
    let highlighted: String
    let highlightColor: Color

    var body: some View {
        Text(attributedString)
			.applyTextStyle(.Label)
			.foregroundStyle(.gray)
    }

    private var attributedString: AttributedString {
        var attributedString = AttributedString(text)

        if let range = attributedString.range(of: highlighted) {
            attributedString[range].foregroundColor = highlightColor
        }

        return attributedString
    }
}

#Preview {
    HighlightedText(text: "All Data is provided by the v2 Climate Clock API from climateclock.world. \n\n Join in and participate in the Climate Clock Community too. \n\n #ClimateClock #ActInTime",
                    highlighted: "v2 Climate Clock API", highlightColor: .red)
}
