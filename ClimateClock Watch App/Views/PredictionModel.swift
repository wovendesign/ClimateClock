//
//  PredictionModel.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//

import SwiftUI

struct PredictionModel: View {
    let model: PredictionModelData
    var textColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .foregroundStyle(textColor)
                .font(
                    .custom("Oswald", size: 18)
                        .weight(.semibold)
                )
                .tracking(0.32)
            HStack(alignment: .firstTextBaseline) {
                if let prefix = model.prefix {
                    Text(prefix)
                        .font(
                            .custom("Assistant", size: 12)
                                .weight(.semibold)
                        )
                        .foregroundStyle(.gray)
                }
                Text(model.temperature)
                    .font(
                        .custom("Oswald", size: 16)
                            .weight(.semibold)
                    )
                    .tracking(0.32)
                Text(model.arrivalDate)
                    .font(
                        .custom("Assistant", size: 12)
                            .weight(.semibold)
                    )
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    PredictionModel(
        model: PredictionModelData(
            title: "Green New Deal",
            prefix: "just under",
            temperature: "1.5°C",
            arrivalDate: "by 2040"
        ),
        textColor: .red
    )
}
