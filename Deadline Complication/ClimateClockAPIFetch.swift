
import Foundation

struct ClimateClockResponse: Decodable {
    let status: String
    let data: ClimateClockData
}

struct ClimateClockData: Decodable {
    let modules: ClimateClockModules
}

struct ClimateClockModules: Decodable {
    let carbonDeadlines: ClimateClockModule
    
    private enum CodingKeys: String, CodingKey {
        case carbonDeadlines = "carbon_deadline_1"
    }
}

struct ClimateClockModule: Decodable {
    // Define properties based on the actual structure of each module
    // Example for "carbon_deadline_1":
    let type: String
    let flavor: String
    let description: String
    let update_interval_seconds: Int
    let timestamp: String
    let labels: [String]
    let lang: String

    // Add more properties based on the specific needs of each module
}



// Example usage
func parseJSON(json: String) -> ClimateClockData? {
    print("starting parsing")
    if let jsonData = json.data(using: .utf8) {
        do {
            
            let climateClockResponse = try JSONDecoder().decode(ClimateClockResponse.self, from: jsonData)
            return climateClockResponse.data
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    return nil
}
