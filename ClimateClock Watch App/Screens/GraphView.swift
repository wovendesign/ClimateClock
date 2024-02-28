//
//  GraphView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//

import SwiftUI
import Charts

struct Test: Identifiable {
    var id = UUID()
    
    var year: Int
    var value: Double
}

struct GraphView: View {
    
    @StateObject var viewModel = GraphViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
			Graph(emissions: viewModel.currentModel?.emissions ?? [],
				  temperatures: viewModel.currentModel?.temperatures ?? [],
				  color: viewModel.currentModel?.color ?? .cyan,
				  gridLines: viewModel.gridLines)
            
            HStack {
                Text("1980")
                    .font(.system(size: 10))
                Spacer()
                Text("2020")
                    .font(.system(size: 10))
                Spacer()
                Text("2060")
                    .font(.system(size: 10))
                Spacer()
                Text("2100")
                    .font(.system(size: 10))
            }
            
            ScrollView {
                VStack {
                    ForEach(viewModel.models) { item in
                        PredictionModel(title: item.title,
                                        peakTemperature: item.peakTemperature,
                                        endTemperature: item.endTemperature,
                                        textColor: item.color)
                        .containerRelativeFrame(.vertical)
                        .scrollTransition { content, phase in
                            content.opacity(phase.isIdentity ? 1.0 : 0)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .defaultScrollAnchor(.center)
			.scrollPosition(id: $viewModel.currentModelId)
            .contentMargins(.vertical, 16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            Spacer()
        }
        .padding(12)
        .background(
			LinearGradient(gradient: Gradient(colors: [.black, viewModel.currentModel?.color ?? Color.red]), 
						   startPoint: .top,
						   endPoint: .bottom)
				.opacity(0.3)
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GraphView()
}
