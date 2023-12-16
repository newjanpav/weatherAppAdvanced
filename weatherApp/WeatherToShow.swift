//
//  WeatherToShow.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation

struct WeatherToShow {
    
    let cityName: String
    let temperature: Double
    let weatherDescription: String
    let weatherId: Int
 
    var temperatureString: String {
        String(format: "%.0f", temperature)
    }
    var weatherImage: String {
        TransformToImage.someCloasure(id: weatherId)
    }
}


struct HourlyWeatherToShow: Codable {
    
    let hour: String
    let hourlyTemperature: Double
    let hourlyWeatherId: Int
    let weatherDescription: String
    
    var temperatureString: String {
        String(format: "%.0f", hourlyTemperature)
    }
    var weatherImage: String {
       return  TransformToImage.someCloasure(id: hourlyWeatherId)
    }
}

struct DailyWeatherToShow: Codable {
    
    let day: String
    let daylyTemperature: Double
    let daylyWeatherId: Int
    
    var temperatureString: String {
        String(format: "%.0f", daylyTemperature)
    }
    var weatherImage: String {
       return TransformToImage.someCloasure(id: daylyWeatherId)
    }
}
    
    
private struct TransformToImage {
    
 static func someCloasure(id: Int) -> String {
        
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud.sun"
        }
    }
}

    

