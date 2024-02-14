//
//  PredictionModel.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 14.02.24.
//

import SwiftUI

struct PredictionModel: View {
    
    var title: String
    var peakTemperature: Double
    var endTemperature: Double
    var textColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(textColor)
                .bold()
            HStack(alignment: .bottom) {
                Text("\(peakTemperature, specifier: "%.2f")°")
                    .font(.system(size: 13))
                    .bold()
                Text("peak Temperature (2100)")
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
            }
            HStack(alignment: .bottom) {
                Text("\(endTemperature, specifier: "%.2f")°")
                    .font(.system(size: 13))
                    .bold()
                Text("by the end of the century")
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    PredictionModel(title: "Business as Usual",
                    peakTemperature: 3.52,
                    endTemperature: 3.52,
                    textColor: .red)
}
