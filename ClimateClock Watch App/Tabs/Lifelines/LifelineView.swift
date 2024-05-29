//
//  LifelineView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftData
import SwiftUI

struct LifelineView: View {
    @Query(sort: \LifeLine.order) var lifeLines: [LifeLine]

    var body: some View {
        TabTitleLayout(headline: "Lifelines",
                       subtitle: "Change is already happening")
        {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEachIndexed(lifeLines) { _, lifeLine in
                        LifeLineCell(lifeLine: lifeLine)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 8.0)
            .padding(.vertical, 16)
        }
        .background(.linearGradient(colors: [.lime.opacity(0.4), .black],
                                    startPoint: .top,
                                    endPoint: .bottom))
    }
}

enum LifeLineSize {
    case Large, Small
}

#Preview {
    LifelineView()
}

struct ForEachIndexed<Data, Item, Content: View>: View where Data: RandomAccessCollection<Item>, Data.Index: Hashable {
    private let sequence: Data
    private let content: (Data.Index, Item) -> Content

    init(_ sequence: Data, @ViewBuilder _ content: @escaping (Data.Index, Item) -> Content) {
        self.sequence = sequence
        self.content = content
    }

    var body: some View {
        ForEach(Array(zip(sequence.indices, sequence)), id: \.0) { index, item in
            self.content(index, item)
        }
    }
}
