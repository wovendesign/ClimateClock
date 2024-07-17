//
//  Client.swift
//  ClimateClock
//
//  Created by Eric Wätke on 14.05.24.
//

import Foundation
import Observation
import SwiftData
import UserNotifications

@Observable public final class Client {
    func getDataFromClimateClockAPI(context: ModelContext) async -> [NewsItem]? {
        do {
            let result = try await NetworkManager.shared.getClimateClockData()

            switch result {
            case let .success(data):
                // Saving LifeLines
//                context.insert(moduleToLifeline(module: data.data.modules._youth_anxiety,
//                                                type: .youth))
                context.insert(moduleToLifeline(module: data.ff_divestment_stand_dot_earth,
                                                type: .divestment))
                context.insert(moduleToLifeline(module: data.indigenous_land_1,
                                                type: .indigenous))
//                context.insert(moduleToLifeline(module: data.loss_damage_g20_debt,
//                                                type: .g20))
                context.insert(moduleToLifeline(module: data.loss_damage_g7_debt,
                                                type: .g7))
                context.insert(moduleToLifeline(module: data.regen_agriculture,
                                                type: .agriculture))
                context.insert(moduleToLifeline(module: data.renewables_1,
                                                type: .renewables))
                context.insert(moduleToLifeline(module: data.women_in_parliaments,
                                                type: .women))

				return data.newsfeed_1.newsfeed

            case let .failure(error):
                switch error {
                case .invalidURL:
                    print("Invalid URL")
					//								alertItem = AlertContext.invalidURL

                case .invalidResponse:
                    print("Invalid Response")
					//								alertItem = AlertContext.invalidReponse

                case .invalidData:
                    print("Invalid Data")
					//								alertItem = AlertContext.invalidData

                case .unableToComplete:
                    print("unableToComplete")
                    //								alertItem = AlertContext.invalidToComplete
                }
				return nil
            }
        } catch {
			print("Couldnt get Data")
            print(error)
        }
		return nil
    }

    func moduleToLifeline(module: LifeLineModule, type: LifeLineType) -> LifeLine {
        let order: Int = {
            switch type {
            case .renewables: return 0
			case .indigenous: return 1
			case .g7: return 2
            case .women: return 3
            case .divestment: return 4
            case .agriculture: return 5
            case .prolife: return 6
            default:
                return 999
            }
        }()

        let goal: String? = {
            switch type {
            case .renewables: return "100% by 2030"
            case .women: return "50% gender parity"
			case .indigenous: return "Protect ALL Indigenous Land"
			case .divestment: return "Defund Fossile Fule Industry"
			case .agriculture: return "Rapidly scale up regenerative practices"
			case .g7: return "Full climate reparations"
            default:
                return nil
            }
        }()

        return LifeLine(order: order,
                        desc: module.description,
                        update_interval_seconds: module.update_interval_seconds,
                        initial: module.initial,
                        timestamp: module.timestamp,
                        growth: module.growth,
                        resolution: module.resolution,
                        rate: module.rate,
                        labels: module.labels,
                        unit_labels: module.unit_labels,
                        goal: goal,
                        type: type)
    }
}
