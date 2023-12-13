//
//  WeatherToShow.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation

struct WeatherToShow: Decodable {
    
    let cityName: String
    let temperature: Double
    let weatherDescription: String
    let weatherId: Int
 
    var temperatureString: String {
        String(format: "%.0f", temperature)
    }

    var weatherImage: String {
        
        switch weatherId {
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


struct HourlyWeatherToShow {
    
    let hour: String
    let hourlyTemperature: Double
    let hourlyWeatherId: Int
    let weatherDescription: String
    
    var temperatureString: String {
        String(format: "%.0f", hourlyTemperature)
    }

    var weatherImage: String {
        
        switch hourlyWeatherId {
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

struct DailyWeatherToShow {
    
    let day: String
    let daylyTemperature: Double
    let daylyWeatherId: Int
    
    var temperatureString: String {
        String(format: "%.0f", daylyTemperature)
    }

    var weatherImage: String {
        
        switch daylyWeatherId {
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
    
    

