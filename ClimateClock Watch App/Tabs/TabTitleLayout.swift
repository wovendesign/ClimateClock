//
//  TabTitleLayout.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 15.05.24.
//

import SwiftUI

struct TabTitleLayout<Content: View>: View {
    let headline: String
    let subtitle: String
    let content: Content?

    init(headline: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.headline = headline
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TabTitle(
                    headline: headline,
                    subtitle: subtitle
                )
                .scrollTransition { content, phase in
                    content.scaleEffect(phase.isIdentity ? 1.0 : 0.8, anchor: .bottom)
                        .blur(radius: !phase.isIdentity ? 3.0 : 0)
                        .opacity(phase.isIdentity ? 1.0 : 0.3)
                }
                .defaultScrollAnchor(.center)
                content
            }
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    TabTitleLayout(headline: "Test Headline", subtitle: "Test Subtitle") {
        Text("test")
    }
}
