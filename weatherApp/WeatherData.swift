//
//  WeatherData.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation

//MARK: - Main Weather Data

struct  WeatherData: Decodable  {
    
    let timeZone: String?
    let cityName: String?
    let coordinates: Coord?
    let temperature: Main?
    let weatherDescription: [Weather]?
    let hourly: [Hourly]?
    let daily: [Daily]?

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperature = "main"
        case weatherDescription = "weather"
        case cityName = "name"
        case hourly
        case timeZone = "timezone"
        case daily
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coordinates =  try? container.decode(Coord.self, forKey: .coordinates)
        self.temperature = try? container.decode(Main.self, forKey: .temperature)
        self.weatherDescription = try? container.decode([Weather].self, forKey: .weatherDescription)
        self.cityName = try? container.decode(String.self, forKey: .cityName)
        self.hourly = try? container.decode([Hourly].self, forKey: .hourly)
        self.timeZone = try? container.decode(String.self, forKey: .timeZone)
        self.daily = try? container.decode([Daily].self, forKey: .daily)
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

//MARK: -  Hourly Forecast

struct Hourly: Decodable {
    
    let dt: TimeInterval?
    let temperature: Double?
    let weather: [Weather]?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case dt
        case weather
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature =  try? container.decode(Double.self, forKey: .temperature)
        self.dt =  try? container.decode(TimeInterval.self, forKey: .dt)
        self.weather =  try? container.decode( [Weather].self, forKey: .weather)
    }
}

//MARK: - Dayly Forecast

struct Daily: Decodable {
    
    let dt: TimeInterval?
    let temperature: Temperature?
    let weather: [Weather]?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case dt
        case weather
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt =  try? container.decode(TimeInterval.self, forKey: .dt)
        self.temperature =  try? container.decode(Temperature.self, forKey: .temperature)
        self.weather =  try? container.decode([Weather].self, forKey: .weather)
    }
}

struct Temperature: Decodable {
    let dayTemperature: Double?
    
    enum CodingKeys: String, CodingKey {
        case dayTemperature = "day"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dayTemperature =  try? container.decode(Double.self, forKey: .dayTemperature)
        
    }
}


