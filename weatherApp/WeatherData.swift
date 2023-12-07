//
//  WeatherData.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation

struct  WeatherData: Decodable {
    
    let cityName: String?
    let coordinates: Coord?
    let temperature: Main?
    let weatherDescription: [Weather]?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperature = "main"
        case weatherDescription = "weather"
        case cityName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coordinates =  try? container.decode(Coord.self, forKey: .coordinates)
        self.temperature = try? container.decode(Main.self, forKey: .temperature)
        self.weatherDescription = try? container.decode([Weather].self, forKey: .weatherDescription)
        self.cityName = try? container.decode(String.self, forKey: .cityName)
    }
}




struct Main: Decodable {
    
    let temperature: Double?
    let temperatureMin: Double?
    let temperatureMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature =  try? container.decode(Double.self, forKey: .temperature)
        self.temperatureMin = try? container.decode(Double.self, forKey: .temperatureMin)
        self.temperatureMax = try? container.decode(Double.self, forKey: .temperatureMax)
    }
}



struct Coord: Decodable {
    
    let longitude: Double?
    let latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.longitude =  try? container.decode(Double.self, forKey: .longitude)
        self.latitude = try? container.decode(Double.self, forKey: .latitude)
    }
}



struct Weather: Decodable {
    
    let id: Int
    let description: String
}

