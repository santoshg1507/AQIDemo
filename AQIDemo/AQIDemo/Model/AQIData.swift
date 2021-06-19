//
//  AQIData.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation

class AQIData: Codable {
    var city: String
    var aqi: Double
    var updatedAt = Date()
    
    var relativeDateString: String {
        return self.updatedAt.relativeDateTime()
    }
    
    enum CodingKeys: String, CodingKey {
        case city, aqi
    }
    
    static func objects(jsonString: String) -> [AQIData]? {
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        do {
            let models = try decoder.decode([AQIData].self, from: jsonData)
            return models
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
