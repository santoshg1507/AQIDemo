//
//  AQIData.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation

struct AQIData: Codable {
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
    
    func aqiRange() -> AQIRange {
        return AQIRange.range(aqi: self.aqi)
    }
    
}

enum AQIRange {
    case good// 0-50
    case satisfactory// 51-100
    case moderate//101-200
    case poor//201-300
    case veryPoor//301-400
    case severe//401-500
    
    func hexColorCode() -> String {
        switch self {
        case .good:
            return "6AA55A"
        case .satisfactory:
            return "ABC564"
        case .moderate:
            return "FFF65F"
        case .poor:
            return "E79E4A"
        case .veryPoor:
            return "D84C3E"
        case .severe:
            return "A2382C"
        }
    }
    
    static func range(aqi: Double) -> AQIRange {
        let aqiInt = Int(aqi)
        switch aqiInt {
        case 0 ... 50:
            return .good
        case 51 ... 100:
            return .satisfactory
        case 101 ... 200:
            return .moderate
        case 201 ... 300:
            return .poor
        case 301 ... 400:
            return .veryPoor
        case 401 ... 500 :
            return .severe
        default:
            return .severe
        }
    }

}

