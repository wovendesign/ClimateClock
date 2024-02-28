//
//  StatsView.swift
//  ClimateClock Watch App
//
//  Created by Eric Wätke on 28.02.24.
//

import SwiftUI

struct FiguresView: View {
    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				StatCell(value: "26.7", unit: "%", label: "Women in parliaments globally")
				StatCell(value: "13.676083240", unit: "%", label: "World's energy from renewables")
				StatCell(value: "$12.8312", unit: "trillion", label: "Loss & damage owed by G7 nations")
				StatCell(value: "$40.60", unit: "trillion", label: "Divested from fossil fuels")
				StatCell(value: "43,500.000", unit: "km²", label: "Land protected by indigenous people")
				StatCell(value: "1,013,455", unit: "HA", label: "Regenerative agriculture")
			}
			.frame(maxWidth: .infinity)
			.padding(.horizontal, 8.0)
		}
		.frame(maxWidth: .infinity)
		.background(.linearGradient(colors: [.black, Color.green.opacity(0.2)], 
									startPoint: .top,
									endPoint: .bottom))
    }
}

struct StatCell: View {
	var value: String
	var unit: String
//	var precision: Int
	var label: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text(value)
					.font(.system(size: 19))
					.fontWeight(.semibold)
				Text(unit)
					.font(.lowercaseSmallCaps(.system(size: 19))())
					.fontWeight(.semibold)
			}
				.padding(EdgeInsets(top: 6,
									leading: 4,
									bottom: 6,
									trailing: 4))
				.background(.linearGradient(colors: [Color.green.opacity(0.2), Color.blue.opacity(0.2)], 
											startPoint: .leading,
											endPoint: .trailing))
				.clipShape(.rect(cornerRadius: 6))
			Text(label)
				.font(.system(size: 12))
				.fontWeight(.semibold)
				.foregroundStyle(Color.white.opacity(0.8))
		}
	}
}

#Preview {
	FiguresView()
}
