//
//  WeatherToShow.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation

class WeatherToShow: Decodable {
    
    let temperature: Int
    let temperatureMax: Int
    let temperatureMin: Int
    let weatherDescription: String
    var weatherId: Int
    
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
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
