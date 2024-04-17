//
//  GraphView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//

import Charts
import SwiftUI

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
            if let model = viewModel.currentModel {
                ZStack {
                    Graph(
                        emissions: model.emissions,
                        temperatures: model.temperatures,
                        color: Color.red,
                        gridLines: viewModel.gridLines
                    )
                    .animation(.bouncy, value: viewModel.currentModel)
                    .opacity(model.color == .red ? 1 : 0)

                    Graph(
                        emissions: model.emissions,
                        temperatures: model.temperatures,
                        color: Color.orange,
                        gridLines: viewModel.gridLines
                    )
                    .animation(.bouncy, value: viewModel.currentModel)
                    .opacity(model.color == .orange ? 1 : 0)

                    Graph(
                        emissions: model.emissions,
                        temperatures: model.temperatures,
                        color: .lime,
                        gridLines: viewModel.gridLines
                    )
                    .animation(.bouncy, value: viewModel.currentModel)
                    .opacity(model.color == .lime ? 1 : 0)
                }
                .frame(maxHeight: .infinity)
            }
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

            //			ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.models) { item in
                        PredictionModel(
                            model: item.model,
                            textColor: item.color
                        )
                        .containerRelativeFrame(.vertical)
                        .scrollTransition { content, phase in
                            content.opacity(phase.isIdentity ? 1.0 : 0)
                        }
                        //							.id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .defaultScrollAnchor(.center)
            .scrollPosition(id: $viewModel.currentModelId)
            .contentMargins(.vertical, 16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            //				.onAppear {
            //					proxy.scrollTo(viewModel.models.first?.id)
            //				}
            //			}
        }
        .padding(12)
        .background(
            LinearGradient(gradient: Gradient(colors: [viewModel.currentModel?.color ?? .red, .black]),
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
